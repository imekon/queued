unit animation.entry;

interface

uses
  System.Types, System.SysUtils;

type
  TAnimationType = (FadeIn, FadeOut, MoveTo);

  TAnimationEntry = class
  private
    m_type: TAnimationType;
    m_duration: single;
    m_point: TPointF;
  public
    constructor Create(animation: TAnimationType; duration: single); overload;
    constructor Create(animation: TAnimationType; duration, x, y: single); overload;

    function ToString: string; override;

    property AnimationType: TAnimationType read m_type;
    property Duration: single read m_duration;
  end;

implementation

{ TAnimationEntry }

constructor TAnimationEntry.Create(animation: TAnimationType; duration: single);
begin
  m_type := animation;
  m_duration := duration;
  m_point.X := 0;
  m_point.Y := 0;
end;

constructor TAnimationEntry.Create(animation: TAnimationType; duration, x,
  y: single);
begin
  m_type := animation;
  m_duration := duration;
  m_point.X := x;
  m_point.Y := y;
end;

function TAnimationEntry.ToString: string;
var
  text: string;

begin
  case m_type of
    FadeIn:   text := 'FadeIn: ';
    FadeOut:  text := 'FadeOut: ';
    MoveTo:   text := 'MoveTo: ';
  end;

  text := text + FloatToStr(m_duration);
  result := text;
end;

end.
