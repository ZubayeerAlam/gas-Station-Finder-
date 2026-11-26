import 'package:flutter_test/flutter_test.dart';
import 'package:gas_station_finder/features/garage/domain/vehicle_profile.dart';
import 'package:gas_station_finder/features/history/domain/fill_up.dart';
import 'package:gas_station_finder/features/history/domain/fill_up_csv.dart';

const car = VehicleProfile(id: 'v1', name: 'Axio', energyType: EnergyType.fuel, consumptionPer100Km: 7, capacity: 40);

FillUp f(
  String id,
  DateTime date, {
  double amount = 20,
  double cost = 2500,
  double? odo,
  bool full = true,
  String? station,
}) => FillUp(
  id: id,
  vehicleId: 'v1',
  date: date,
  amount: amount,
  totalCost: cost,
  currencyCode: 'BDT',
  odometerKm: odo,
  isFull: full,
  stationName: station,
);

void main() {
  test('header, BOM, CRLF, oldest first, plain numbers', () {
    final csv = FillUpCsv.build(car, [
      f('b', DateTime(2026, 11, 20, 18, 5), amount: 30.5, cost: 3812.5, odo: 12345.67, full: false, station: 'Meghna'),
      f('a', DateTime(2026, 11, 1, 9), odo: 12000),
    ]);
    expect(csv.startsWith(FillUpCsv.bom), isTrue);
    final lines = csv.substring(1).split('\r\n');
    expect(lines, [
      'date,vehicle,amount,unit,total_cost,currency,unit_price,odometer_km,full_fill,station',
      '2026-11-01 09:00,Axio,20,L,2500,BDT,125,12000,yes,',
      '2026-11-20 18:05,Axio,30.5,L,3812.5,BDT,125,12345.7,no,Meghna',
      '',
    ]);
  });

  test('EV unit, missing odometer, Bengali text kept', () {
    const ev = VehicleProfile(
      id: 'e',
      name: 'ইভি',
      energyType: EnergyType.electric,
      consumptionPer100Km: 15,
      capacity: 60,
    );
    final csv = FillUpCsv.build(ev, [f('a', DateTime(2026, 1, 2), amount: 10, cost: 120, station: 'পদ্মা চার্জিং')]);
    expect(csv.split('\r\n')[1], '2026-01-02 00:00,ইভি,10,kWh,120,BDT,12,,yes,পদ্মা চার্জিং');
  });

  test('quoting and formula injection are defused', () {
    expect(FillUpCsv.cell('A, B'), '"A, B"');
    expect(FillUpCsv.cell('say "hi"'), '"say ""hi"""');
    expect(FillUpCsv.cell('two\nlines'), '"two\nlines"');
    expect(FillUpCsv.cell('=HYPERLINK("x")'), '"\'=HYPERLINK(""x"")"');
    expect(FillUpCsv.cell('+1'), "'+1");
    expect(FillUpCsv.cell('-cmd'), "'-cmd");
    expect(FillUpCsv.cell('@sum'), "'@sum");
    expect(FillUpCsv.cell(''), '');
    final csv = FillUpCsv.build(car, [f('a', DateTime(2026), station: '=1+1')]);
    expect(csv, contains(",'=1+1\r\n"));
  });

  test('empty history is just the header', () {
    expect(FillUpCsv.build(car, const []), '${FillUpCsv.bom}${FillUpCsv.columns.join(',')}\r\n');
  });

  test('file name is a safe ASCII slug with the date', () {
    final now = DateTime(2026, 11, 27);
    expect(FillUpCsv.fileName(car, now), 'fuelwise_axio_2026-11-27.csv');
    expect(
      FillUpCsv.fileName(car.copyWith(name: ' My Car #2 / Dhaka '), now),
      'fuelwise_my-car-2-dhaka_2026-11-27.csv',
    );
    expect(FillUpCsv.fileName(car.copyWith(name: 'গাড়ি'), now), 'fuelwise_vehicle_2026-11-27.csv');
    expect(FillUpCsv.fileName(car.copyWith(name: '../../etc'), now), 'fuelwise_etc_2026-11-27.csv');
  });
}
