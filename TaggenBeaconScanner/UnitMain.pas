//---------------------------------------------------------------------------
// Copyright (c) 2019 Taggen Sistemas
//
// http://www.taggen.com.br
//
// Sample for scanning BLE Beacons
//
// This sample is based on Embarcadero Sample
// Original sources at
// https://community.idera.com/developer-tools/b/blog/posts/extended-beacon-sample-for-delphi-10-1-berlin-standard-alternative-and-eddystone-beacons
//---------------------------------------------------------------------------

unit UnitMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, System.Beacon,
  System.Beacon.Components, FMX.Layouts, FMX.ListBox, FMX.StdCtrls,
  FMX.Controls.Presentation, System.Bluetooth, System.Bluetooth.Components, System.Math,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView, System.Actions, FMX.ActnList, FMX.ExtCtrls, FMX.Objects,
    {$IF Defined(IOS)}
    macapi.helpers, iOSapi.Foundation, FMX.helpers.iOS;
    {$ELSEIF Defined(ANDROID)}
    Androidapi.JNI.GraphicsContentViewText,
    Androidapi.JNI.Net,
    Androidapi.JNI.App,
    Androidapi.helpers;
    {$ELSEIF Defined(MACOS)}
    Posix.Stdlib;
    {$ELSEIF Defined(MSWINDOWS)}
    Winapi.ShellAPI, Winapi.Windows;
    {$ENDIF}

  type

  TRssiToDistance = function (ARssi, ATxPower: Integer; ASignalPropagationConst: Single): Double of object;

  TFormMain = class(TForm)
    panelMain: TPanel;
    btnScan: TButton;
    Beacon1: TBeacon;
    Timer1: TTimer;
    listBeacons: TListView;
    StyleBook1: TStyleBook;
    panelScanMode: TPanel;
    CheckBoxStandard: TCheckBox;
    CheckBoxAlternative: TCheckBox;
    CheckBoxScanEddystone: TCheckBox;
    CheckBoxExtended: TCheckBox;
    Label2: TLabel;
    panelTop: TPanel;
    panelExtendedMode: TPanel;
    CheckBoxAltBeacon: TCheckBox;
    CheckBoxEddystone: TCheckBox;
    CheckBoxiBeacon: TCheckBox;
    CheckBoxDeviceInf: TCheckBox;
    labelExtendedMode: TLabel;
    Layout1: TLayout;
    labelSupport: TLabel;
    labelAbout: TLabel;
    logoTaggen: TImage;
    procedure btnScanClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure CheckBoxiBeaconChange(Sender: TObject);
    procedure CheckBoxiScanningChange(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Beacon1NewBLEScanFilter(const Sender: TObject;
      AKindofScanFilter: TKindofScanFilter;
      const ABluetoothLEScanFilter: TBluetoothLEScanFilter);
    procedure FormCreate(Sender: TObject);
    procedure labelSupportClick(Sender: TObject);
    procedure labelAboutClick(Sender: TObject);
    procedure labelTaggenClick(Sender: TObject);
  private
    // FBeacon : IBeacon;
    // FRssiToDistance: TRssiToDistance;
    FCurrentBeaconList: TBeaconList;
    // FTXCount: Integer;
    // FTXArray: Array [0..99] of integer;
    FBluetoothLEDeviceList: TBluetoothLEDeviceList;
  public
    function GetScanningModeChecked: TBeaconScanMode;
    function GetKindOfBeaconsChecked: TKindofBeacons;
  end;

var
  FormMain: TFormMain;
  isScanning: Boolean;

implementation

{$R *.fmx}

procedure TFormMain.FormCreate(Sender: TObject);
begin
   isScanning := False;
end;

//procedure TForm1.Beacon1CalculateDistances(const Sender: TObject;
//  const ABeacon: IBeacon; ATxPower, ARssi: Integer; var NewDistance: Double);
//var
//  I: Integer;
//begin // This event is used if we want to use our own calcDistance formula
//  if not Assigned(FRssiToDistance) then
//    FRssiToDistance := TBluetoothLEManager.Current.RssiToDistance;
////property LastDiscoveredDevices: TBluetoothLEDeviceList read FDiscoveredLEDevices;
//  NewDistance := System.Math.RoundTo(FRssiToDistance(ARssi, ATXPower, 0.5), DISTANCE_DECIMALS);
//  if FCurrentBeaconList <> nil then
//    for I := 0 to Length(FCurrentBeaconList) - 1 do
//    begin
//      if I >= FTXCount then
//        Inc(FTXCount);
//      if ABeacon.DeviceIdentifier = FCurrentBeaconList[I].DeviceIdentifier then
//        FTXArray[I] := ATxPower;
//    end;
//end;

procedure TFormMain.Beacon1NewBLEScanFilter(const Sender: TObject;
  AKindofScanFilter: TKindofScanFilter;
  const ABluetoothLEScanFilter: TBluetoothLEScanFilter);
var
  TB: TBytes;
  LServiceDataRawData: TServiceDataRawData;
begin
//  if ABluetoothLEScanFilter <> nil then
//  begin
//    case AKindofScanFilter of
//      TKindofScanFilter.ManufacturerData: TB := ABluetoothLEScanFilter.ManufacturerSpecificData;
//      TKindofScanFilter.ServiceData:  LServiceDataRawData := ABluetoothLEScanFilter.ServiceData;
//      TKindofScanFilter.Service: showmessage(ABluetoothLEScanFilter.ServiceUUID.tostring);
//    end;
//  end;
end;

procedure TFormMain.btnScanClick(Sender: TObject);
var
  I: Integer;
begin
  if (isScanning) then
  Begin
    // STOP
    Timer1.Enabled := False;
    Beacon1.StopScan;
    btnScan.Text := 'PROCURAR';
    //For I := 0 to panelExtendedMode.ChildrenCount-1 do
    //Begin
    //   if (panelExtendedMode.Children.Items[I] is TCheckBox) then
    //     (panelExtendedMode.Children.Items[I] as TCheckBox).Enabled := True;
    //End;
    panelExtendedMode.Visible := True;
  End
  Else Begin
    //For I := 0 to panelExtendedMode.ChildrenCount-1 do
    //Begin
    //   if (panelExtendedMode.Children.Items[I] is TCheckBox) then
    //     (panelExtendedMode.Children.Items[I] as TCheckBox).Enabled := False;
    //End;
    panelExtendedMode.Visible := False;

    listBeacons.Items.Clear;

    Beacon1.Mode := GetScanningModeChecked;
    Beacon1.ModeExtended := GetKindOfBeaconsChecked;
    if not(Beacon1.Enabled) then
    begin
      Beacon1.Enabled := True;
    end
    else
    begin
      Beacon1.StartScan;
    end;

    Timer1.Enabled := True;
    btnScan.Text := 'PARAR';
  End;

  isScanning := Not(isScanning);
end;


function TFormMain.GetKindOfBeaconsChecked: TKindofBeacons;
begin
  Result := [];
  if CheckBoxiBeacon.IsChecked then
    Result := [TKindofBeacon.iBeacons];
  if CheckBoxAltBeacon.IsChecked then
    Result := Result + [TKindofBeacon.AltBeacons];
  if CheckBoxEddystone.IsChecked then
    Result := Result + [TKindofBeacon.Eddystones];
end;

function TFormMain.GetScanningModeChecked: TBeaconScanMode;
begin
  // PanelScanMode visible was set to false
  // Taggen beacons can be scanned using  TBeaconScanMode.Extended

  exit(TBeaconScanMode.Extended);

  (*
  if (CheckBoxStandard.IsChecked) then
    exit(TBeaconScanMode.Standard);
  if (CheckBoxAlternative.IsChecked) then
    exit(TBeaconScanMode.Alternative);
  if (CheckBoxScanEddystone.IsChecked) then
    exit(TBeaconScanMode.Eddystone);
  if (CheckBoxExtended.IsChecked) then
    exit(TBeaconScanMode.Extended);
  *)
end;

procedure TFormMain.labelAboutClick(Sender: TObject);
begin
   ShowMessage('Versão 1.0, Fev. 2019');
end;

procedure TFormMain.labelSupportClick(Sender: TObject);
{$IF Defined(ANDROID)}
var
  Intent: JIntent;
{$ENDIF}
begin
{$IF Defined(ANDROID)}
  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  Intent.setData(StrToJURI('https://taggen.zendesk.com/hc/pt-br'));
  tandroidhelper.Activity.startActivity(Intent);
  // SharedActivity.startActivity(Intent);
{$ELSEIF Defined(MSWINDOWS)}
  ShellExecute(0, 'OPEN', PWideChar('https://taggen.zendesk.com/hc/pt-br'), nil, nil, SW_SHOWNORMAL);
{$ELSEIF Defined(IOS)}
  SharedApplication.OpenURL(StrToNSUrl('https://taggen.zendesk.com/hc/pt-br'));
{$ELSEIF Defined(MACOS)}
  _system(PAnsiChar('open ' + AnsiString('https://taggen.zendesk.com/hc/pt-br')));
{$ENDIF}
end;

procedure TFormMain.labelTaggenClick(Sender: TObject);
{$IF Defined(ANDROID)}
var
  Intent: JIntent;
{$ENDIF}
begin
{$IF Defined(ANDROID)}
  Intent := TJIntent.Create;
  Intent.setAction(TJIntent.JavaClass.ACTION_VIEW);
  Intent.setData(StrToJURI('http://www.taggen.com.br'));
  tandroidhelper.Activity.startActivity(Intent);
  // SharedActivity.startActivity(Intent);
{$ELSEIF Defined(MSWINDOWS)}
  ShellExecute(0, 'OPEN', PWideChar('http://www.taggen.com.br'), nil, nil, SW_SHOWNORMAL);
{$ELSEIF Defined(IOS)}
  SharedApplication.OpenURL(StrToNSUrl('http://www.taggen.com.br'));
{$ELSEIF Defined(MACOS)}
  _system(PAnsiChar('open ' + AnsiString('http://www.taggen.com.br')));
{$ENDIF}
end;

procedure TFormMain.CheckBoxiScanningChange(Sender: TObject);
begin
  if TCheckBox(Sender).IsChecked then
  begin
  if TCheckBox(Sender) <> CheckBoxStandard then
    CheckBoxStandard.IsChecked := False;
  if TCheckBox(Sender) <> CheckBoxAlternative then
    CheckBoxAlternative.IsChecked := False;
  if TCheckBox(Sender) <> CheckBoxScanEddystone then
    CheckBoxScanEddystone.IsChecked := False;
  if TCheckBox(Sender) <> CheckBoxExtended then
    CheckBoxExtended.IsChecked := False;
  end;
end;

procedure TFormMain.CheckBoxiBeaconChange(Sender: TObject);
//var
//  LKindofBeacons: TKindofBeacons;
begin
//  if not (csLoading in ComponentState) then
//    Beacon1.StopScan;
end;

procedure TFormMain.FormShow(Sender: TObject);
begin
   case Beacon1.Mode of  // TBeaconScanMode = (Standard, Alternative, Eddystone, Extended);
     TBeaconScanMode.Standard:
       begin
        CheckBoxStandard.IsChecked := True;
        CheckBoxAlternative.IsChecked := False;
        CheckBoxEddystone.IsChecked := False;
        CheckBoxExtended.IsChecked := False;
       end;
     TBeaconScanMode.Alternative:
       begin
        CheckBoxStandard.IsChecked := False;
        CheckBoxAlternative.IsChecked := True;
        CheckBoxEddystone.IsChecked := False;
        CheckBoxExtended.IsChecked := False;
       end;
     TBeaconScanMode.Eddystone:
       begin
        CheckBoxStandard.IsChecked := False;
        CheckBoxAlternative.IsChecked := False;
        CheckBoxEddystone.IsChecked := True;
        CheckBoxExtended.IsChecked := False;
       end;
     TBeaconScanMode.Extended:
       begin
        CheckBoxStandard.IsChecked := False;
        CheckBoxAlternative.IsChecked := False;
        CheckBoxEddystone.IsChecked := False;
        CheckBoxExtended.IsChecked := True;
       end;
   end;

  if TKindofBeacon.iBeacons in Beacon1.ModeExtended then
    CheckBoxiBeacon.IsChecked := True
  else
    CheckBoxiBeacon.IsChecked := False;

  if TKindofBeacon.AltBeacons in Beacon1.ModeExtended then
    CheckBoxAltBeacon.IsChecked := True
  else
    CheckBoxAltBeacon.IsChecked := False;

  if TKindofBeacon.Eddystones in Beacon1.ModeExtended then
    CheckBoxEddystone.IsChecked := True
  else
    CheckBoxEddystone.IsChecked := False;
end;

procedure TFormMain.Timer1Timer(Sender: TObject);
var
  I,B: Integer;
  Pos, NOfDevices: Integer;
  ST1, ST2, TX: string;
  DeviceName, DeviceIdentifier: string;
  LEddystoneTLM: TEddystoneTLM;
  LEddyHandler: IEddystoneBeacon;
  LiBeacon: IiBeacon;
  LAltBeacon: IAltBeacon;
  MSData: TBytes;
  isDeviceInfChecked: Boolean;

  procedure PrintIt(const Line1: string = ''; const Line2: string = '');
  var
    LItem: TListViewItem;
  begin
   Inc(Pos);
   if (listBeacons.Items.Count - 1) < Pos then
     LItem := listBeacons.Items.Add;
    listBeacons.Items[Pos].Text := Line1;
    listBeacons.Items[Pos].Detail := Line2;
  end;

begin
  try
    FCurrentBeaconList := Beacon1.BeaconList;

    // This is a Backdoor to get acces to the BLE devices (TBluetoothLEDevice) associated to Beacons.
    if FBluetoothLEDeviceList = nil then
      FBluetoothLEDeviceList := TBluetoothLEManager.Current.LastDiscoveredDevices;

    Pos := -1;
    isDeviceInfChecked := CheckBoxDeviceInf.IsChecked;

    if Length(FCurrentBeaconList) > 0 then
    begin
      // The access to BLE Devices is not Thread Safe so we must protect it under its objectList Monitor
      TMonitor.Enter(FBluetoothLEDeviceList);
      try
        if isDeviceInfChecked then
          NOfDevices := FBluetoothLEDeviceList.Count
        else
          NOfDevices := 1;

        for B := 0 to NOfDevices - 1 do
        begin
          if isDeviceInfChecked then
          begin
            DeviceIdentifier := FBluetoothLEDeviceList[B].Identifier;
            DeviceName := FBluetoothLEDeviceList[B].DeviceName;
          end
          else
            DeviceIdentifier := '';
          if DeviceName = '' then
            DeviceName := 'No Name';

          for I := 0 to Length(FCurrentBeaconList) - 1 do
            if (FCurrentBeaconList[I] <> nil) and (FCurrentBeaconList[I].itsAlive) and
              ((not isDeviceInfChecked) or (DeviceIdentifier = FCurrentBeaconList[I].DeviceIdentifier)) then // There are BLE Devices that advertised two or more kind of beacons.
            begin
              ST1 := '';
              ST2 := '';
              TX := '';
              case FCurrentBeaconList[I].KindofBeacon of
                TKindofBeacon.iBeacons:
                  if (Supports(FCurrentBeaconList[I], IiBeacon, LiBeacon)) then
                  begin
                    ST1 := 'iBeacon, GUID: ' + LiBeacon.GUID.ToString+#13+'Major: ' + LiBeacon.Major.ToString+' Minor: ' + LiBeacon.Minor.ToString;
                    if isDeviceInfChecked then
                    begin
                      MSData := FBluetoothLEDeviceList[B].ScannedAdvertiseData.ManufacturerSpecificData;
                      if Length(MSData) = STANDARD_DATA_LENGTH  then // There are BLE Devices that advertised two or more kind of beacons, so The MSData might Change.
                        TX := ShortInt(MSData[Length(MSData) - 1]).ToString
                      else
                        TX := ShortInt(MSData[Length(MSData) - 2]).ToString;
                    end;
                  end;

                TKindofBeacon.AltBeacons:
                  if (Supports(FCurrentBeaconList[I], IAltBeacon, LAltBeacon)) then
                  begin
                    ST1 := 'AltBeacon, GUID: ' + LAltBeacon.GUID.ToString+#13+'Major: ' + LAltBeacon.Major.ToString+' Minor: ' + LAltBeacon.Minor.ToString;
                    if isDeviceInfChecked then
                    begin
                      MSData := FBluetoothLEDeviceList[B].ScannedAdvertiseData.ManufacturerSpecificData;
                      if Length(MSData) = STANDARD_DATA_LENGTH  then // There are BLE Devices that advertise tw0 or more kind of beacons, so The MSData might Change.
                        TX := ShortInt(MSData[Length(MSData) - 1]).ToString
                      else
                        TX := ShortInt(MSData[Length(MSData) - 2]).ToString;
                     end;
                  end;

                 TKindofBeacon.Eddystones:
                   begin
                     if (Supports(FCurrentBeaconList[I], IEddystoneBeacon, LEddyHandler)) then
                     begin
                       ST1 := 'Eddystone'+#13+' ';
                       if isDeviceInfChecked then
                         MSData := FBluetoothLEDeviceList[B].ScannedAdvertiseData.ServiceData[0].Value;

                       if  (TKindofEddystone.UID in LEddyHandler.KindofEddystones) then
                       begin
                         ST1 := 'Eddystone, UID-NameSpace: '+LEddyHandler.EddystoneUID.NamespaceToString
                           +#13+ 'UID-Instance: '+LEddyHandler.EddystoneUID.InstanceToString;
                         if isDeviceInfChecked and (MSData[EDDY_FRAMETYPE_POS] = EDDYSTONE_UID) then
                           TX := ShortInt(MSData[EDDY_TX_POS] - EDDY_SIGNAL_LOSS_METER).ToString + '/UID';
                       end;

                       if TKindofEddystone.URL in LEddyHandler.KindofEddystones then
                       begin
                         ST2 := ST2 +#13+'URL: ' + LEddyHandler.EddystoneURL.URL;
                         if isDeviceInfChecked and (MSData[EDDY_FRAMETYPE_POS] = EDDYSTONE_URL) then
                           TX := ShortInt(MSData[EDDY_TX_POS] - EDDY_SIGNAL_LOSS_METER).ToString + '/URL';
                       end;

                       if TKindofEddystone.TLM in LEddyHandler.KindofEddystones then
                       begin
                         ST2 := ST2 +#13+'TLM:  BattVol: '+ LEddyHandler.EddystoneTLM.BattVoltageToString +
                         ', B.Temp: '+LEddyHandler.EddystoneTLM.BeaconTempToString;
                         ST2 := ST2 +#13+'  AdvPDUCount: '+LEddyHandler.EddystoneTLM.AdvPDUCountToString+
                         ', SincePOn: '+LEddyHandler.EddystoneTLM.TimeSincePowerOnToString;

                         if isDeviceInfChecked and (MSData[EDDY_FRAMETYPE_POS] = EDDYSTONE_TLM) then
                           TX := '/TLM';
                       end;

                     end;
                   end;
               end;

             ST2 := ST2 +#13+ DeviceName + ', ID: '+   DeviceIdentifier+#13;
             if isDeviceInfChecked then
               ST2 := ST2 +'TX: '+TX+', ';
              ST2 := ST2+'RSSI:'+FCurrentBeaconList[I].Rssi.ToString+', Distance: '+FCurrentBeaconList[I].Distance.ToString+' m';
             PrintIt(ST1,ST2);
           end;
        end;

      finally
        TMonitor.Exit(FBluetoothLEDeviceList);
      end;

      if (listBeacons.Items.Count - 1) > Pos then
        for I := listBeacons.Items.Count - 1 downto Pos + 1 do
          listBeacons.Items.Delete(I);
    end;

  except
    On E : Exception do
      ShowMessage(E.Message);
  end;
end;

end.
