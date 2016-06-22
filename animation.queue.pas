unit animation.queue;

interface

uses
  System.Classes, System.Generics.Collections, System.Threading,
  System.SysUtils, System.SyncObjs, System.Math,
  animation.entry;

type
  TAnimationQueue = class
  private
    m_running: boolean;
    m_queue: TThreadedQueue<TAnimationEntry>;
    m_task: ITask;
    m_event: TLightweightEvent;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Start;
    procedure Stop;

    procedure FadeIn(dur: single);
    procedure FadeOut(dur: single);
    procedure MoveTo(x, y, dur: single);
  end;

implementation

{ TAnimationQueue }

constructor TAnimationQueue.Create;
begin
  m_running := false;
  m_queue := TThreadedQueue<TAnimationEntry>.Create;
  m_event := TLightweightEvent.Create;
end;

destructor TAnimationQueue.Destroy;
begin
  m_queue.DoShutDown;
  m_event.Free;
  m_queue.Free;
  inherited;
end;

procedure TAnimationQueue.FadeIn(dur: single);
var
  entry: TAnimationEntry;

begin
  entry := TAnimationEntry.Create(TAnimationType.FadeIn, dur);
  m_queue.PushItem(entry);
  m_event.SetEvent;
end;

procedure TAnimationQueue.FadeOut(dur: single);
var
  entry: TAnimationEntry;

begin
  entry := TAnimationEntry.Create(TAnimationType.FadeOut, dur);
  m_queue.PushItem(entry);
  m_event.SetEvent;
end;

procedure TAnimationQueue.MoveTo(x, y, dur: single);
var
  entry: TAnimationEntry;

begin
  entry := TAnimationEntry.Create(TAnimationType.MoveTo, dur, x, y);
  m_queue.PushItem(entry);
  m_event.SetEvent;
end;

procedure TAnimationQueue.Start;
begin
  m_task := TTask.Create(procedure()
  var
    wait: TWaitResult;
    entry: TAnimationEntry;

  begin
    m_running := true;
    while m_running do
    begin
      wait := m_event.WaitFor;
      WriteLn('Event set');

      if not m_running then
        break;

      if wait = TWaitResult.wrSignaled then
      begin
        wait := m_queue.PopItem(entry);
        if wait = TWaitResult.wrSignaled then
        begin
          WriteLn('Processing: ', entry.ToString);
          sleep(floor(entry.Duration * 1000));
          WriteLn('Done');
          entry.Free;
        end;
        m_event.ResetEvent;
      end;
    end;
  end);

  m_task.Start;
end;

procedure TAnimationQueue.Stop;
begin
  m_running := false;
  m_event.SetEvent;
end;

end.
