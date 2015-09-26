{$APPTYPE CONSOLE}

uses
  SysUtils,
  ActiveX,
  ComObj;

//This code adds an ICMP rule using the Microsoft Windows Firewall APIs.
Procedure AddICMPRule;
Const
 NET_FW_ACTION_ALLOW = 1;
 NET_FW_IP_PROTOCOL_ICMPv4 = 1;
 NET_FW_IP_PROTOCOL_ICMPv6 = 58;
var
 CurrentProfiles : OleVariant;
 fwPolicy2       : OleVariant;
 RulesObject     : OleVariant;
 NewRule         : OleVariant;
begin
  // Create the FwPolicy2 object.
  fwPolicy2   := CreateOleObject('HNetCfg.FwPolicy2');
  RulesObject := fwPolicy2.Rules;
  CurrentProfiles := fwPolicy2.CurrentProfileTypes;

  //Create a Rule Object.
  NewRule := CreateOleObject('HNetCfg.FWRule');

  NewRule.Name := 'ICMP_Rule';
  NewRule.Description := 'Allow ICMP network traffic';
  NewRule.Protocol := NET_FW_IP_PROTOCOL_ICMPv4;
  NewRule.IcmpTypesAndCodes := '1:1';
  NewRule.Enabled := True;
  NewRule.Grouping := 'My Group';
  NewRule.Profiles := CurrentProfiles;
  NewRule.Action := NET_FW_ACTION_ALLOW;

  //Add a new rule
  RulesObject.Add(NewRule);
end;

begin
 try
    CoInitialize(nil);
    try
      AddICMPRule;
    finally
      CoUninitialize;
    end;
 except
    on E:EOleException do
        Writeln(Format('EOleException %s %x', [E.Message,E.ErrorCode]));
    on E:Exception do
        Writeln(E.Classname, ':', E.Message);
 end;
 Writeln('Press Enter to exit');
 Readln;
end.