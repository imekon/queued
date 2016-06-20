program queued;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  animation.queue in 'animation.queue.pas',
  animation.entry in 'animation.entry.pas';

var
  queue: TAnimationQueue;

begin
  queue := TAnimationQueue.Create;
  queue.Start;
  queue.FadeIn(3);

  sleep(5000);

  queue.Stop;

  WriteLn('Press RETURN when ready...');
  ReadLn;
end.
