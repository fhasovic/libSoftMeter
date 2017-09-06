program console_demo_delphi10;

{$APPTYPE CONSOLE}

//////////////////////////////////////////////////////////////
///
///     console_demo_delphi10.dpr
///
///     demo delphi/pascal program for the libAppTelemetry
///     Copyright, StarMessage software
///     https://www.starmessagesoftware.com/libapptelemetry
///
//////////////////////////////////////////////////////////////


uses
  SysUtils,
  strUtils,
  dll_loader in 'dll_loader.pas';


function checkCommandLineParam:boolean;
// do some simple checking
begin
    if (ParamCount<>1) then
    begin
        result:=false;
        exit;
    end;
    result:=AnsiStartsStr('UA-', ParamStr(1));
end;


const   programVer = '1.2';
        DLLfilename =  'libAppTelemetry.dll';

var     appTelemetryDll:TDllAppTelemetry;
        googleAnalyticsPropertyID:PAnsiChar;

begin

  try
    writeln('console_demo_delphi10 v'+ programVer +' started.');

    if checkCommandLineParam=false then
    begin
        writeln('Call this program with a one parameter, the Google Property ID, e.g.' + CHR(13) + CHR(10) +
                'console_demo_delphi10 UA-123456-01');
        exit;
    end;

    appTelemetryDll := TDllAppTelemetry.Create(DLLfilename);
    if (appTelemetryDll.isLoaded)
        then
            writeln('DLL loaded.')
        else
            writeln('DLL NOT loaded. The DLL "' + DLLfilename + '" must be in the same folder as the executable.');

    writeln('DLL version: ', appTelemetryDll.appTelemetryGetVersion);
    writeln('Enabling the log file. Check the log file for the duration of the telemetry functions.');
    appTelemetryDll.appTelemetryEnableLogfile(true);
    writeln('DLL log filename: ', appTelemetryDll.appTelemetryGetLogFilename);

    googleAnalyticsPropertyID :=  PAnsiChar(AnsiString(ParamStr(1)));
    writeln('Will send data to the Google Property ID:' +  googleAnalyticsPropertyID);

    if not appTelemetryDll.appTelemetryInit('console demo delphi', '0.1', googleAnalyticsPropertyID) then
        writeLn('appTelemetryInit failed.');

    if not appTelemetryDll.appTelemetryAddPageview('main window', 'main window') then
        writeLn('appTelemetryAddPageview failed.');

    // e.g. the user opens the configuration screen of your program
    if not appTelemetryDll.appTelemetryAddPageview('main window/configuration', 'configuration') then
        writeLn('appTelemetryAddPageview failed.');

    // ........  more of your code here


    // eg. the user hits the exit button
    if not appTelemetryDll.appTelemetryAddPageview('exit', 'exit') then
        writeLn('appTelemetryAddPageview failed.');

    appTelemetryDll.appTelemetryFree;

    // destroy the object so that the DLL is also unloaded
    if assigned(appTelemetryDll) then
        appTelemetryDll.Free;

    writeln('console_demo_delphi10 exiting.');

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;

end.