{*******************************************************}
{                                                       }
{       FMX UI �й�ũ�����ݵ�Ԫ                         }
{                                                       }
{       ��Ȩ���� (C) 2017 YangYxd                       }
{                                                       }
{*******************************************************}

{
  ע�⣺
   ����Ԫ���ݲ����� Jea��(JJonline@JJonline.Cn) JavaScript ���������
   �����㷨�������Ż����޸ġ�
   http://blog.jjonline.cn/userInterFace/173.html/comment-page-2
}

unit UI.Calendar.Data;

interface

uses
  UI.Utils,
  Classes, SysUtils, Math, DateUtils;

type
  /// <summary>
  /// ũ����Ϣ
  /// </summary>
  TLunarData = record
  private
    iTerm: SmallInt;
    iUpdateGZM: Boolean;
    function GetAnimalStr: string;
    function GetAstro: string;
    function GetGanZhi: string;
    function GetGanZhiDay: string;
    function GetGanZhiMonth: string;
    function GetGanZhiYear: string;
    function GetIsTerm: Boolean;
    function GetTermStr: string;
    function GetCnDay: string;
    function GetCnMonth: string;
    function GetCnYear: string;
  public
    // ����������
    Y, M, D: Word;
    // ũ���꣬�£��գ�����
    Year, Month, Day: Word;
    // �Ƿ�����
    IsLeap: Boolean;

    // ����ũ�������������ַ���
    function ToString(): string;

    // ��Ф
    property Animal: string read GetAnimalStr;
    // �������
    property IsTerm: Boolean read GetIsTerm;
    // ��������
    property Term: string read GetTermStr;
    // ��ɵ�֧
    property GanZhi: string read GetGanZhi;
    property GanZhiYear: string read GetGanZhiYear;
    property GanZhiMonth: string read GetGanZhiMonth;
    property GanZhiDay: string read GetGanZhiDay;
    // ����
    property Astro: string read GetAstro;

    property CnYear: string read GetCnYear;
    property CnMonth: string read GetCnMonth;
    property CnDay: string read GetCnDay;
  end;

/// <summary>
/// ���빫�������գ������ϸ��ũ����Ϣ
/// </summary>
function SolarToLunar(const Value: TDateTime = 0): TLunarData; overload;
function SolarToLunar(Y, M, D: Word): TLunarData; overload;

/// <summary>
/// ����ũ���������Լ�������·��Ƿ����»�ù�������
/// <param name="IsLeapMonth">�����·��Ƿ�Ϊ����</param>
/// </summary>
function LunarToSolar(const Y, M, D: Word; IsLeapMonth: Boolean = False): TDateTime;

implementation

const
  /// <summary>
  /// ũ�� 1900 - 2100 �����С��Ϣ��
  /// </summary>
  LunarInfo: array [0..200] of Integer = (
    $04bd8, $04ae0, $0a570, $054d5, $0d260, $0d950, $16554, $056a0, $09ad0, $055d2, //1900-1909
    $04ae0, $0a5b6, $0a4d0, $0d250, $1d255, $0b540, $0d6a0, $0ada2, $095b0, $14977, //1910-1919
    $04970, $0a4b0, $0b4b5, $06a50, $06d40, $1ab54, $02b60, $09570, $052f2, $04970, //1920-1929
    $06566, $0d4a0, $0ea50, $06e95, $05ad0, $02b60, $186e3, $092e0, $1c8d7, $0c950, //1930-1939
    $0d4a0, $1d8a6, $0b550, $056a0, $1a5b4, $025d0, $092d0, $0d2b2, $0a950, $0b557, //1940-1949
    $06ca0, $0b550, $15355, $04da0, $0a5b0, $14573, $052b0, $0a9a8, $0e950, $06aa0, //1950-1959
    $0aea6, $0ab50, $04b60, $0aae4, $0a570, $05260, $0f263, $0d950, $05b57, $056a0, //1960-1969
    $096d0, $04dd5, $04ad0, $0a4d0, $0d4d4, $0d250, $0d558, $0b540, $0b6a0, $195a6, //1970-1979
    $095b0, $049b0, $0a974, $0a4b0, $0b27a, $06a50, $06d40, $0af46, $0ab60, $09570, //1980-1989
    $04af5, $04970, $064b0, $074a3, $0ea50, $06b58, $055c0, $0ab60, $096d5, $092e0, //1990-1999
    $0c960, $0d954, $0d4a0, $0da50, $07552, $056a0, $0abb7, $025d0, $092d0, $0cab5, //2000-2009
    $0a950, $0b4a0, $0baa4, $0ad50, $055d9, $04ba0, $0a5b0, $15176, $052b0, $0a930, //2010-2019
    $07954, $06aa0, $0ad50, $05b52, $04b60, $0a6e6, $0a4e0, $0d260, $0ea65, $0d530, //2020-2029
    $05aa0, $076a3, $096d0, $04afb, $04ad0, $0a4d0, $1d0b6, $0d250, $0d520, $0dd45, //2030-2039
    $0b5a0, $056d0, $055b2, $049b0, $0a577, $0a4b0, $0aa50, $1b255, $06d20, $0ada0, //2040-2049
    // Add By JJonline@JJonline.Cn
    $14b63, $09370, $049f8, $04970, $064b0, $168a6, $0ea50, $06b20, $1a6c4, $0aae0, //2050-2059
    $0a2e0, $0d2e3, $0c960, $0d557, $0d4a0, $0da50, $05d55, $056a0, $0a6d0, $055d4, //2060-2069
    $052d0, $0a9b8, $0a950, $0b4a0, $0b6a6, $0ad50, $055a0, $0aba4, $0a5b0, $052b0, //2070-2079
    $0b273, $06930, $07337, $06aa0, $0ad50, $14b55, $04b60, $0a570, $054e4, $0d160, //2080-2089
    $0e968, $0d520, $0daa0, $16aa6, $056d0, $04ae0, $0a9d4, $0a2d0, $0d150, $0f252, //2090-2099
    $0d520
  );

  /// <summary>
  /// ����ÿ���·ݵ�������ͨ��
  /// </summary>
  SolarMonth: array [0..11] of Integer = (
    31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31
  );

  /// <summary>
  /// ��ɵ�֧֮����ٲ��
  /// </summary>
  Gan: array [0..9] of string = (
    '��', '��', '��', '��', '��', '��', '��', '��', '��', '��'
  );

  /// <summary>
  /// ��ɵ�֧֮��֧�ٲ��
  /// </summary>
  Zhi: array [0..11] of string = (
    '��', '��', '��', 'î', '��', '��',
    '��', 'δ', '��', '��', '��', '��'
  );

  /// <summary>
  /// ��ɵ�֧֮��֧�ٲ�� - ��Ф
  /// </summary>
  Animals: array [0..11] of string = (
    '��', 'ţ', '��', '��', '��', '��',
    '��', '��', '��', '��', '��', '��'
  );

  /// <summary>
  /// 24�����ٲ��
  /// </summary>
  SolarTerms: array [0..23] of string = (
    'С��', '��', '����', '��ˮ', '����', '����', '����', '����',
    '����', 'С��', 'â��', '����', 'С��', '����', '����', '����',
    '��¶', '���', '��¶', '˪��', '����', 'Сѩ', '��ѩ', '����'
  );

  /// <summary>
  /// 1900-2100�����24���������ٲ��
  /// </summary>
  STermInfo: array [0..200] of string = (
    '9778397bd097c36b0b6fc9274c91aa', '97b6b97bd19801ec9210c965cc920e', '97bcf97c3598082c95f8c965cc920f',
    '97bd0b06bdb0722c965ce1cfcc920f', 'b027097bd097c36b0b6fc9274c91aa', '97b6b97bd19801ec9210c965cc920e',
    '97bcf97c359801ec95f8c965cc920f', '97bd0b06bdb0722c965ce1cfcc920f', 'b027097bd097c36b0b6fc9274c91aa',
    '97b6b97bd19801ec9210c965cc920e', '97bcf97c359801ec95f8c965cc920f', '97bd0b06bdb0722c965ce1cfcc920f',
    'b027097bd097c36b0b6fc9274c91aa', '9778397bd19801ec9210c965cc920e', '97b6b97bd19801ec95f8c965cc920f',
    '97bd09801d98082c95f8e1cfcc920f', '97bd097bd097c36b0b6fc9210c8dc2', '9778397bd197c36c9210c9274c91aa',
    '97b6b97bd19801ec95f8c965cc920e', '97bd09801d98082c95f8e1cfcc920f', '97bd097bd097c36b0b6fc9210c8dc2',
    '9778397bd097c36c9210c9274c91aa', '97b6b97bd19801ec95f8c965cc920e', '97bcf97c3598082c95f8e1cfcc920f',
    '97bd097bd097c36b0b6fc9210c8dc2', '9778397bd097c36c9210c9274c91aa', '97b6b97bd19801ec9210c965cc920e',
    '97bcf97c3598082c95f8c965cc920f', '97bd097bd097c35b0b6fc920fb0722', '9778397bd097c36b0b6fc9274c91aa',
    '97b6b97bd19801ec9210c965cc920e', '97bcf97c3598082c95f8c965cc920f', '97bd097bd097c35b0b6fc920fb0722',
    '9778397bd097c36b0b6fc9274c91aa', '97b6b97bd19801ec9210c965cc920e', '97bcf97c359801ec95f8c965cc920f',
    '97bd097bd097c35b0b6fc920fb0722', '9778397bd097c36b0b6fc9274c91aa', '97b6b97bd19801ec9210c965cc920e',
    '97bcf97c359801ec95f8c965cc920f', '97bd097bd097c35b0b6fc920fb0722', '9778397bd097c36b0b6fc9274c91aa',
    '97b6b97bd19801ec9210c965cc920e', '97bcf97c359801ec95f8c965cc920f', '97bd097bd07f595b0b6fc920fb0722',
    '9778397bd097c36b0b6fc9210c8dc2', '9778397bd19801ec9210c9274c920e', '97b6b97bd19801ec95f8c965cc920f',
    '97bd07f5307f595b0b0bc920fb0722', '7f0e397bd097c36b0b6fc9210c8dc2', '9778397bd097c36c9210c9274c920e',
    '97b6b97bd19801ec95f8c965cc920f', '97bd07f5307f595b0b0bc920fb0722', '7f0e397bd097c36b0b6fc9210c8dc2',
    '9778397bd097c36c9210c9274c91aa', '97b6b97bd19801ec9210c965cc920e', '97bd07f1487f595b0b0bc920fb0722',
    '7f0e397bd097c36b0b6fc9210c8dc2', '9778397bd097c36b0b6fc9274c91aa', '97b6b97bd19801ec9210c965cc920e',
    '97bcf7f1487f595b0b0bb0b6fb0722', '7f0e397bd097c35b0b6fc920fb0722', '9778397bd097c36b0b6fc9274c91aa',
    '97b6b97bd19801ec9210c965cc920e', '97bcf7f1487f595b0b0bb0b6fb0722', '7f0e397bd097c35b0b6fc920fb0722',
    '9778397bd097c36b0b6fc9274c91aa', '97b6b97bd19801ec9210c965cc920e', '97bcf7f1487f531b0b0bb0b6fb0722',
    '7f0e397bd097c35b0b6fc920fb0722', '9778397bd097c36b0b6fc9274c91aa', '97b6b97bd19801ec9210c965cc920e',
    '97bcf7f1487f531b0b0bb0b6fb0722', '7f0e397bd07f595b0b6fc920fb0722', '9778397bd097c36b0b6fc9274c91aa',
    '97b6b97bd19801ec9210c9274c920e', '97bcf7f0e47f531b0b0bb0b6fb0722', '7f0e397bd07f595b0b0bc920fb0722',
    '9778397bd097c36b0b6fc9210c91aa', '97b6b97bd197c36c9210c9274c920e', '97bcf7f0e47f531b0b0bb0b6fb0722',
    '7f0e397bd07f595b0b0bc920fb0722', '9778397bd097c36b0b6fc9210c8dc2', '9778397bd097c36c9210c9274c920e',
    '97b6b7f0e47f531b0723b0b6fb0722', '7f0e37f5307f595b0b0bc920fb0722', '7f0e397bd097c36b0b6fc9210c8dc2',
    '9778397bd097c36b0b70c9274c91aa', '97b6b7f0e47f531b0723b0b6fb0721', '7f0e37f1487f595b0b0bb0b6fb0722',
    '7f0e397bd097c35b0b6fc9210c8dc2', '9778397bd097c36b0b6fc9274c91aa', '97b6b7f0e47f531b0723b0b6fb0721',
    '7f0e27f1487f595b0b0bb0b6fb0722', '7f0e397bd097c35b0b6fc920fb0722', '9778397bd097c36b0b6fc9274c91aa',
    '97b6b7f0e47f531b0723b0b6fb0721', '7f0e27f1487f531b0b0bb0b6fb0722', '7f0e397bd097c35b0b6fc920fb0722',
    '9778397bd097c36b0b6fc9274c91aa', '97b6b7f0e47f531b0723b0b6fb0721', '7f0e27f1487f531b0b0bb0b6fb0722',
    '7f0e397bd097c35b0b6fc920fb0722', '9778397bd097c36b0b6fc9274c91aa', '97b6b7f0e47f531b0723b0b6fb0721',
    '7f0e27f1487f531b0b0bb0b6fb0722', '7f0e397bd07f595b0b0bc920fb0722', '9778397bd097c36b0b6fc9274c91aa',
    '97b6b7f0e47f531b0723b0787b0721', '7f0e27f0e47f531b0b0bb0b6fb0722', '7f0e397bd07f595b0b0bc920fb0722',
    '9778397bd097c36b0b6fc9210c91aa', '97b6b7f0e47f149b0723b0787b0721', '7f0e27f0e47f531b0723b0b6fb0722',
    '7f0e397bd07f595b0b0bc920fb0722', '9778397bd097c36b0b6fc9210c8dc2', '977837f0e37f149b0723b0787b0721',
    '7f07e7f0e47f531b0723b0b6fb0722', '7f0e37f5307f595b0b0bc920fb0722', '7f0e397bd097c35b0b6fc9210c8dc2',
    '977837f0e37f14998082b0787b0721', '7f07e7f0e47f531b0723b0b6fb0721', '7f0e37f1487f595b0b0bb0b6fb0722',
    '7f0e397bd097c35b0b6fc9210c8dc2', '977837f0e37f14998082b0787b06bd', '7f07e7f0e47f531b0723b0b6fb0721',
    '7f0e27f1487f531b0b0bb0b6fb0722', '7f0e397bd097c35b0b6fc920fb0722', '977837f0e37f14998082b0787b06bd',
    '7f07e7f0e47f531b0723b0b6fb0721', '7f0e27f1487f531b0b0bb0b6fb0722', '7f0e397bd097c35b0b6fc920fb0722',
    '977837f0e37f14998082b0787b06bd', '7f07e7f0e47f531b0723b0b6fb0721', '7f0e27f1487f531b0b0bb0b6fb0722',
    '7f0e397bd07f595b0b0bc920fb0722', '977837f0e37f14998082b0787b06bd', '7f07e7f0e47f531b0723b0b6fb0721',
    '7f0e27f1487f531b0b0bb0b6fb0722', '7f0e397bd07f595b0b0bc920fb0722', '977837f0e37f14998082b0787b06bd',
    '7f07e7f0e47f149b0723b0787b0721', '7f0e27f0e47f531b0b0bb0b6fb0722', '7f0e397bd07f595b0b0bc920fb0722',
    '977837f0e37f14998082b0723b06bd', '7f07e7f0e37f149b0723b0787b0721', '7f0e27f0e47f531b0723b0b6fb0722',
    '7f0e397bd07f595b0b0bc920fb0722', '977837f0e37f14898082b0723b02d5', '7ec967f0e37f14998082b0787b0721',
    '7f07e7f0e47f531b0723b0b6fb0722', '7f0e37f1487f595b0b0bb0b6fb0722', '7f0e37f0e37f14898082b0723b02d5',
    '7ec967f0e37f14998082b0787b0721', '7f07e7f0e47f531b0723b0b6fb0722', '7f0e37f1487f531b0b0bb0b6fb0722',
    '7f0e37f0e37f14898082b0723b02d5', '7ec967f0e37f14998082b0787b06bd', '7f07e7f0e47f531b0723b0b6fb0721',
    '7f0e37f1487f531b0b0bb0b6fb0722', '7f0e37f0e37f14898082b072297c35', '7ec967f0e37f14998082b0787b06bd',
    '7f07e7f0e47f531b0723b0b6fb0721', '7f0e27f1487f531b0b0bb0b6fb0722', '7f0e37f0e37f14898082b072297c35',
    '7ec967f0e37f14998082b0787b06bd', '7f07e7f0e47f531b0723b0b6fb0721', '7f0e27f1487f531b0b0bb0b6fb0722',
    '7f0e37f0e366aa89801eb072297c35', '7ec967f0e37f14998082b0787b06bd', '7f07e7f0e47f149b0723b0787b0721',
    '7f0e27f1487f531b0b0bb0b6fb0722', '7f0e37f0e366aa89801eb072297c35', '7ec967f0e37f14998082b0723b06bd',
    '7f07e7f0e47f149b0723b0787b0721', '7f0e27f0e47f531b0723b0b6fb0722', '7f0e37f0e366aa89801eb072297c35',
    '7ec967f0e37f14998082b0723b06bd', '7f07e7f0e37f14998083b0787b0721', '7f0e27f0e47f531b0723b0b6fb0722',
    '7f0e37f0e366aa89801eb072297c35', '7ec967f0e37f14898082b0723b02d5', '7f07e7f0e37f14998082b0787b0721',
    '7f07e7f0e47f531b0723b0b6fb0722', '7f0e36665b66aa89801e9808297c35', '665f67f0e37f14898082b0723b02d5',
    '7ec967f0e37f14998082b0787b0721', '7f07e7f0e47f531b0723b0b6fb0722', '7f0e36665b66a449801e9808297c35',
    '665f67f0e37f14898082b0723b02d5', '7ec967f0e37f14998082b0787b06bd', '7f07e7f0e47f531b0723b0b6fb0721',
    '7f0e36665b66a449801e9808297c35', '665f67f0e37f14898082b072297c35', '7ec967f0e37f14998082b0787b06bd',
    '7f07e7f0e47f531b0723b0b6fb0721', '7f0e26665b66a449801e9808297c35', '665f67f0e37f1489801eb072297c35',
    '7ec967f0e37f14998082b0787b06bd', '7f07e7f0e47f531b0723b0b6fb0721', '7f0e27f1487f531b0b0bb0b6fb0722'
  );

  /// <summary>
  /// ����ת�����ٲ��
  /// </summary>
  nStr1: array [0 .. 11] of string = (
    '��', 'һ', '��', '��', '��', '��', '��', '��', '��', '��', 'ʮ', '��'
  );

  /// <summary>
  /// ����תũ���ƺ��ٲ��
  /// </summary>
  nStr2: array [0 .. 3] of string = ( '��', 'ʮ', 'إ', 'ئ' );

  /// <summary>
  /// �·�תũ���ƺ��ٲ��
  /// </summary>
  nStr3: array [0 .. 11] of string = (
    '��','��','��','��','��','��','��','��','��','ʮ','��','��'
  );

  nStr4: array [0 .. 3] of string = (
    '��', '��', '��', '��'
  );

const
  UTC19001031 = -2206396800000;

var
  LYearDaysCacle: array of Integer;

const
  UnixDateDelta: Extended = 25569;
  SecsPerDay: Int64 = 86400000;

// ����ָ��������UTCʱ�� (��JavaScriptһ��)
function UTC(const Y, M, D: Word): Int64;
var
  LDate: TDateTime;
begin
  if TryEncodeDate(Y, M, D, LDate) then begin
    Result := Round((LDate - UnixDateDelta) * SecsPerDay); // - 28800000;
  end else
    Result := 0;
end;

function UTCToDateTime(const V: Int64): TDateTime;
begin
  Result := V / SecsPerDay + UnixDateDelta;
end;

// ����ũ��y���������ĸ��£���y��û������ �򷵻�0
function LeapMonth(const Y: Word): Integer; inline;
begin
  Result := LunarInfo[Y - 1900] and $F;
end;

// ����ũ��y�����µ����� ������û�������򷵻�0
function LeapDays(const Y: Word): Integer;
begin
  if LeapMonth(Y) <> 0 then begin
    if LunarInfo[Y-1900] and $10000 <> 0 then
      Result := 30
    else
      Result := 29;
  end else
    Result := 0;
end;

// ����ũ��y��һ�����������
function InnerGetYearDays(const Y: Word): Integer;
var
  I, Sum: Integer;
begin
  Sum := 348;
  I := $8000;
  while I > $8 do begin
    if (LunarInfo[Y - 1900] and I) <> 0 then
      Inc(Sum);
    I := I shr 1;
  end;
  Result := Sum + LeapDays(Y);
end;

function GetYearDays(const Y: Word): Integer; inline;
begin
  Result := LYearDaysCacle[Y - 1900];
end;

// ����ũ��y��m�£������£���������������mΪ����ʱ��������ʹ��leapDays����
function GetMonthDays(const Y, M: Word): Integer;
begin
  if (M > 12) or (M < 1) then
    Result := -1
  else begin
    if LunarInfo[Y-1900] and ($10000 shr M) <> 0 then
      Result := 30
    else
      Result := 29;
  end;
end;

procedure InitYearDaysCacle();
var
  I: Integer;
begin
  SetLength(LYearDaysCacle, 201);
  for I := 1900 to 2100 do
    LYearDaysCacle[I - 1900] := InnerGetYearDays(I);
end;

function SolarToLunar(const Value: TDateTime): TLunarData;
var
  Y, M, D: Word;
begin
  if Value = 0 then
    Result := SolarToLunar(0, 0, 0)
  else begin
    DecodeDate(Value, Y, M, D);
    Result := SolarToLunar(Y, M, D);
  end;
end;

// ũ�����ת��Ϊ��֧����
function ToGanZhiYear(const Year: Word): string;
var
  ganKey, zhiKey: Integer;
begin
  ganKey := (Year - 3) mod 10;
  zhiKey := (Year - 3) mod 12;
  if (ganKey = 0) then ganKey := 10; //�������Ϊ0��Ϊ���һ�����
  if (zhiKey = 0) then zhiKey := 12; //�������Ϊ0��Ϊ���һ����֧
  Result := Gan[ganKey - 1] + Zhi[zhiKey - 1];
end;

/// <summary>
/// ����offsetƫ�������ظ�֧
/// <param name="Offset">��Լ��ӵ�ƫ����</param>
/// </summary>
function ToGanZhi(const Offset: Integer): string;
begin
  Result := Gan[offset mod 10] + Zhi[offset mod 12];
end;

// ����ũ�������·ݷ��غ���ͨ�ױ�ʾ��
function ToChinaMonth(const M: Word): string;
begin
  if (M > 12) or (M < 1) then
    Result := ''
  else
    Result := nStr3[M - 1] + nStr4[1];
end;

// ����ũ���������ַ��غ��ֱ�ʾ��
function ToChinaDay(const D: Word): string;
begin
  case D of
    10: Result := '��ʮ';
    20: Result := '��ʮ';
    30: Result := '��ʮ';
  else
    begin
      Result := nStr2[Floor(D div 10)] + nStr1[D mod 10];
    end;
  end;
end;

/// <summary>
/// ���빫��(!)y���ø����n�������Ĺ�������
/// <param name="Y">������(1900-2100) </param>
/// <param name="N">��ʮ�Ľ����еĵڼ�������(1~24)����n=1(С��)����</param>
/// </summary>
function GetTerm(const Y, N: Integer): Integer;
const
  CALDAY: array [0..23] of SmallInt =
    (0,0,0,0, 1,1,1,1, 2,2,2,2, 3,3,3,3, 4,4,4,4, 5,5,5,5);
  CALDAYL: array [0..23] of SmallInt =
    (0,1,3,4, 0,1,3,4, 0,1,3,4, 0,1,3,4, 0,1,3,4, 0,1,3,4);
  CALDAYE: array [0..23] of SmallInt =
    (1,2,1,2, 1,2,1,2, 1,2,1,2, 1,2,1,2, 1,2,1,2, 1,2,1,2);
var
  LTable: string;
  P: PChar;
  I: Integer;
begin
  Result := -1;
  if (Y < 1900) or (Y > 2100) then Exit;
  if (N < 1) or (N > 24) then Exit;
  LTable := STermInfo[Y - 1900];
  P := PChar(LTable);

  I := CALDAY[N - 1];
  LTable := IntToStr(PHexToIntDef(P + I * 5, 5));
  P := PChar(LTable);

  I := N - 1;
  Result := PCharToIntDef(P+CALDAYL[I], CALDAYE[I]);
end;

function SolarToLunar(Y, M, D: Word): TLunarData;
var
  offset, I, temp, Leap: Integer;
  firstNode, secondNode: Integer;
begin
  FillChar(Result, SizeOf(Result), 0);
  // δ���λ�õ���
  if (Y = 0) and (M = 0) and (D = 0) then
    DecodeDate(Now, Y, M, D);

  Result.Y := Y;
  Result.M := M;
  Result.D := D;
  Result.iTerm := -1;
  Result.iUpdateGZM := False;

  //����޶�������
  if (Y < 1900) or (Y > 2100) then
    Exit;
  //��������������
  if (Y = 1900) and (M = 1) and (D < 31) then
    Exit;

  offset := (UTC(Y, M, D) - UTC19001031) div 86400000;
  temp := 0;

  I := 1900;
  while (I < 2101) and (offset > 0) do begin
    temp := GetYearDays(I);
    Dec(offset, temp);
    Inc(I);
  end;
  if offset < 0 then begin
    offset := offset + temp;
    Dec(I);
  end;

  // ũ����
  Result.Year := I;
  Leap := LeapMonth(I); //���ĸ���
  Result.IsLeap := False;

  //Ч������
  I := 1;
  while (I <= 12) and (offset > 0) do begin
    //����
    if (Leap > 0) and (not Result.IsLeap) and (I = (Leap)+1) then begin
      Dec(i);
      Result.IsLeap := True;
      temp := LeapDays(Result.Year); //����ũ����������
    end else
      temp := GetMonthDays(Result.Year, I); //����ũ����ͨ������
    //�������
    if Result.IsLeap and (I = Leap+1) then
      Result.IsLeap := False;
    Dec(Offset, temp);
    Inc(I);
  end;

  // ���µ��������±��ص�ȡ��
  if (offset = 0) and (Leap > 0) and (I = Leap+1) then begin
    if Result.IsLeap then
      Result.IsLeap := False
    else begin
      Result.IsLeap := True;
      Dec(I);
    end;
  end;
  if (offset < 0) then begin
    offset := offset + temp;
    Dec(I);
  end;
  //ũ����
  Result.Month := I;
  //ũ����
  Result.Day := offset + 1;

  // ���µ���������
  firstNode := GetTerm(Y, M * 2 - 1);  //���ص��¡��ڡ�Ϊ���տ�ʼ
  secondNode := GetTerm(Y, M * 2);  //���ص��¡��ڡ�Ϊ���տ�ʼ
  // �Ƿ���Ҫ���ݽ���������֧��
  Result.iUpdateGZM := D >= firstNode;

  if firstNode = D then
    Result.iTerm := M * 2 - 2;
  if secondNode = D then
    Result.iTerm := M * 2 - 1;
end;

function LunarToSolar(const Y, M, D: Word; IsLeapMonth: Boolean): TDateTime;
var
  I: Integer;
  leapMon, day, offset, leap: Integer;
  isAdd: Boolean;
  stmap: Int64;
begin
  Result := 0;
  leapMon := LeapMonth(Y);
  if IsLeapMonth and (leapMon <> M) then
    IsLeapMonth := False; //����Ҫ���������¹��� ������ó��������봫�ε��·ݲ���ͬ
  if (Y = 2100) and (M = 12) and (D > 30) then
    Exit;
  if (Y = 1900) and (M = 1) and (D < 1) then
    Exit;

  day := GetMonthDays(Y, M);
  if IsLeapMonth then
    day := LeapDays(Y);

  if (Y < 1900) or (Y > 2100) or (D > day) then
    Exit;

  offset := 0;
  for I := 1900 to Y - 1 do
    offset := offset + GetYearDays(I);

  isAdd := False;
  leap := LeapMonth(Y);
  for I := 1 to M - 1 do begin
    if not isAdd then begin
      if (leap <= i) and (leap > 0) then begin   //��������
        Inc(offset, LeapDays(Y));
        isAdd := True;
      end;
    end;
    Inc(offset, GetMonthDays(Y, I));
  end;

  //ת������ũ�� �貹��������µ�ǰһ���µ�ʱ��
  if IsLeapMonth then
    Inc(offset, day);

  //stmap := UTC(1900, 1, 30);
  stmap := (Int64(offset + D - 31) * 86400 + -2203804800) * 1000;
  Result := UTCToDateTime(stmap);
end;

{ TLunarData }

function TLunarData.GetAnimalStr: string;
begin
  Result := Animals[(Y - 4) mod 12];
end;

function TLunarData.GetAstro: string;
const
  CStr = 'ħ��ˮƿ˫������ţ˫�Ӿ�зʨ�Ӵ�Ů�����Ы����ħ��';
  ARR: array [0..11] of Integer = (20,19,21,21,21,22,23,23,23,23,22,22);

  function GetIndex(): Integer;
  begin
    Result := M * 2 + 1;
    if D < ARR[M - 1] then
      Dec(Result, 2);
  end;

begin
  Result := Copy(CStr, GetIndex, 2) + nStr4[3];
end;

function TLunarData.GetCnDay: string;
begin
  Result := ToChinaDay(Day)
end;

function TLunarData.GetCnMonth: string;
begin
  Result := ToChinaMonth(Month)
end;

function TLunarData.GetCnYear: string;

  function VV(const I: Integer): string;
  begin
    if I = 0 then
      Result := nStr1[11]
    else if (I >= 1) and (I <= 9) then
      Result := nStr1[I]
    else
      Result := '';
  end;

var
  L: string;
  I: Integer;
begin
  L := IntToStr(Year);
  Result := '';
  for I := 1 to Length(L) do
    Result := Result + VV(StrToIntDef(L[I], 0));
  Result := Result + nStr4[0];
end;

function TLunarData.GetGanZhi: string;
begin
  Result := GanZhiYear + nStr4[0] + GanZhiMonth + GanZhiDay;
end;

function TLunarData.GetGanZhiDay: string;
var
  dayCyclical: Integer;  // ���� ����һ���� 1900/1/1 �������
begin
  dayCyclical := UTC(Y, M, 1) div 86400000 + 25567 + 10;
  Result := ToGanZhi(dayCyclical + D - 1);
end;

function TLunarData.GetGanZhiMonth: string;
begin
  if iUpdateGZM then
    Result := ToGanZhi((Y - 1900) * 12 + M + 12)  // ����12����������֧��
  else
    Result := ToGanZhi((Y - 1900) * 12 + M + 11)
end;

function TLunarData.GetGanZhiYear: string;
begin
  Result := ToGanZhiYear(Year);
end;

function TLunarData.GetIsTerm: Boolean;
begin
  Result := iTerm >= 0;
end;

function TLunarData.GetTermStr: string;
begin
  if iTerm < 0 then
    Result := ''
  else
    Result := SolarTerms[iTerm];
end;

function TLunarData.ToString: string;
begin
  Result := CnYear + CnMonth + CnDay;
end;

initialization
  InitYearDaysCacle();

end.
