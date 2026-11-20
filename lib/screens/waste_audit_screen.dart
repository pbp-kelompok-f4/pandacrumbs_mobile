import 'package:flutter/material.dart';

import '../theme/panda_theme.dart';
import '../widgets/panda_chrome.dart';

class WasteAuditScreen extends StatefulWidget {
  const WasteAuditScreen({super.key, required this.onNavigate});

  final ValueChanged<int> onNavigate;

  @override
  State<WasteAuditScreen> createState() => _WasteAuditScreenState();
}

class _WasteAuditScreenState extends State<WasteAuditScreen> {
  final List<WasteRecord> _records = [
    WasteRecord(
      id: 1,
      name: 'Nasi putih',
      quantity: '1,5',
      unit: 'porsi',
      date: DateTime(2026, 10, 25),
      reason: 'Porsi berlebih',
      loss: 7500,
    ),
    WasteRecord(
      id: 2,
      name: 'Susu kemasan',
      quantity: '250',
      unit: 'ml',
      date: DateTime(2026, 10, 24),
      reason: 'Kedaluwarsa',
      loss: 6000,
    ),
    WasteRecord(
      id: 3,
      name: 'Bayam',
      quantity: '1',
      unit: 'ikat',
      date: DateTime(2026, 10, 23),
      reason: 'Rusak atau basi',
      loss: 4000,
    ),
    WasteRecord(
      id: 4,
      name: 'Roti tawar',
      quantity: '3',
      unit: 'lembar',
      date: DateTime(2026, 10, 22),
      reason: 'Rusak atau basi',
      loss: 2500,
    ),
    WasteRecord(
      id: 5,
      name: 'Pisang',
      quantity: '2',
      unit: 'buah',
      date: DateTime(2026, 10, 21),
      reason: 'Terlalu matang',
      loss: 2000,
    ),
    WasteRecord(
      id: 6,
      name: 'Tomat',
      quantity: '3',
      unit: 'buah',
      date: DateTime(2026, 10, 20),
      reason: 'Rusak atau basi',
      loss: 2500,
    ),
    WasteRecord(
      id: 7,
      name: 'Tempe',
      quantity: '0,5',
      unit: 'papan',
      date: DateTime(2026, 10, 19),
      reason: 'Kedaluwarsa',
      loss: 3500,
    ),
    WasteRecord(
      id: 8,
      name: 'Wortel',
      quantity: '1',
      unit: 'buah',
      date: DateTime(2026, 10, 18),
      reason: 'Porsi berlebih',
    ),
  ];

  bool _showForm = false;
  bool _filtersApplied = false;
  WasteRecord? _editingRecord;
  DateTime? _dateFrom;
  DateTime? _dateTo;
  String _reasonFilter = 'Semua alasan';

  static const _reasons = <String>[
    'Rusak atau basi',
    'Kedaluwarsa',
    'Porsi berlebih',
    'Terlalu matang',
    'Lainnya',
  ];

  int get _totalLoss =>
      _records.fold<int>(0, (sum, record) => sum + (record.loss ?? 0));
  int get _pricedRecordCount =>
      _records.where((record) => record.loss != null).length;

  int get _mostCommonReasonCount {
    if (_records.isEmpty) return 0;
    final counts = <String, int>{};
    for (final record in _records) {
      counts.update(record.reason, (count) => count + 1, ifAbsent: () => 1);
    }
    return counts.values.fold<int>(
      0,
      (max, count) => count > max ? count : max,
    );
  }

  String get _mostCommonReason {
    if (_records.isEmpty) return 'Belum ada catatan';
    final counts = <String, int>{};
    for (final record in _records) {
      counts.update(record.reason, (count) => count + 1, ifAbsent: () => 1);
    }
    return counts.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  List<WasteRecord> get _visibleRecords {
    if (!_filtersApplied) return _records;
    return _records.where((record) {
      final afterStart =
          _dateFrom == null ||
          !DateTime(
            record.date.year,
            record.date.month,
            record.date.day,
          ).isBefore(
            DateTime(_dateFrom!.year, _dateFrom!.month, _dateFrom!.day),
          );
      final beforeEnd =
          _dateTo == null ||
          !DateTime(
            record.date.year,
            record.date.month,
            record.date.day,
          ).isAfter(DateTime(_dateTo!.year, _dateTo!.month, _dateTo!.day));
      final reasonMatches =
          _reasonFilter == 'Semua alasan' || record.reason == _reasonFilter;
      return afterStart && beforeEnd && reasonMatches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return PandaPageBackdrop(
      child: _showForm ? _buildForm() : _buildDashboard(),
    );
  }

  Widget _buildDashboard() {
    final records = _visibleRecords;
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AuditPageHeader(onNavigate: widget.onNavigate),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Food Waste Audit',
                  style: TextStyle(
                    fontFamily: 'Gloock',
                    fontSize: 30,
                    height: 1.12,
                    letterSpacing: -.5,
                    color: PandaColors.ink,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Lihat apa yang terbuang, kenapa, dan berapa nilainya.',
                  style: TextStyle(
                    color: Color(0xFF77766D),
                    fontSize: 13.5,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 62),
                OutlinedButton.icon(
                  onPressed: _openAddForm,
                  icon: const Icon(Icons.add_rounded, size: 18),
                  label: const Text('Tambah catatan'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: PandaColors.terracottaDark,
                    side: const BorderSide(
                      color: PandaColors.terracotta,
                      width: 1.6,
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                    shape: const StadiumBorder(),
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
          _AuditMetricCard(
            colors: const [Color(0xFFF3B28D), Color(0xFFFFF0D9)],
            icon: Icons.account_balance_wallet_outlined,
            overline: 'Semua catatan',
            title: 'Perkiraan kerugian',
            value: 'Rp${_formatMoney(_totalLoss)}',
            caption:
                'Nilai diisi pada $_pricedRecordCount dari ${_records.length} catatan.',
          ),
          _AuditMetricCard(
            colors: const [Color(0xFFC7D9A6), Color(0xFFEBF1DB)],
            icon: Icons.receipt_long_outlined,
            title: 'Catatan terbuang',
            value: '${_records.length}',
            valueSuffix: ' catatan',
            caption: 'Jumlah kejadian yang dicatat.',
          ),
          _AuditMetricCard(
            colors: const [Color(0xFFF5D985), Color(0xFFFFF1C4)],
            icon: Icons.fact_check_outlined,
            title: 'Alasan paling sering',
            value: _mostCommonReason,
            caption: 'Tercatat $_mostCommonReasonCount kali.',
            compactValue: true,
          ),
          _HistoryPanel(
            records: records,
            totalRecordCount: _records.length,
            dateFrom: _dateFrom,
            dateTo: _dateTo,
            reason: _reasonFilter,
            onDateFrom: (date) => setState(() => _dateFrom = date),
            onDateTo: (date) => setState(() => _dateTo = date),
            onReasonChanged: (value) => setState(() => _reasonFilter = value),
            onApply: () => setState(() => _filtersApplied = true),
            onReset: _resetFilters,
            onEdit: _openEditForm,
            onDelete: _deleteRecord,
          ),
          const _AuditFooter(),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _AuditPageHeader(onNavigate: widget.onNavigate),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 12, 15, 32),
            child: InkWell(
              onTap: () => setState(() {
                _showForm = false;
                _editingRecord = null;
              }),
              borderRadius: BorderRadius.circular(12),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.arrow_back_rounded,
                      color: PandaColors.oliveDark,
                      size: 19,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Kembali ke riwayat',
                      style: TextStyle(
                        color: PandaColors.oliveDark,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AddWasteNoteForm(
            key: ValueKey(_editingRecord?.id ?? 'new'),
            initialRecord: _editingRecord,
            onCancel: () => setState(() {
              _showForm = false;
              _editingRecord = null;
            }),
            onSave: _saveRecord,
          ),
          const _AuditFooter(),
        ],
      ),
    );
  }

  void _openAddForm() {
    setState(() {
      _editingRecord = null;
      _showForm = true;
    });
  }

  void _openEditForm(WasteRecord record) {
    setState(() {
      _editingRecord = record;
      _showForm = true;
    });
  }

  void _saveRecord(WasteRecord record) {
    setState(() {
      final existingIndex = _records.indexWhere((item) => item.id == record.id);
      if (existingIndex == -1) {
        _records.insert(0, record);
      } else {
        _records[existingIndex] = record;
      }
      _showForm = false;
      _editingRecord = null;
      _filtersApplied = false;
      _dateFrom = null;
      _dateTo = null;
      _reasonFilter = 'Semua alasan';
    });
    showPandaMessage(context, 'Catatan berhasil disimpan.');
  }

  Future<void> _deleteRecord(WasteRecord record) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: PandaColors.paper,
        title: const Text(
          'Hapus catatan?',
          style: TextStyle(fontFamily: 'Gloock', color: PandaColors.ink),
        ),
        content: Text('Catatan ${record.name} akan dihapus dari riwayat.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Batal',
              style: TextStyle(color: PandaColors.muted),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: PandaColors.terracotta,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (shouldDelete != true || !mounted) return;
    setState(() => _records.removeWhere((item) => item.id == record.id));
    showPandaMessage(context, 'Catatan dihapus dari riwayat.');
  }

  void _resetFilters() {
    setState(() {
      _dateFrom = null;
      _dateTo = null;
      _reasonFilter = 'Semua alasan';
      _filtersApplied = false;
    });
  }
}

class WasteRecord {
  const WasteRecord({
    required this.id,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.date,
    required this.reason,
    this.loss,
  });

  final int id;
  final String name;
  final String quantity;
  final String unit;
  final DateTime date;
  final String reason;
  final int? loss;
}

class _AuditPageHeader extends StatelessWidget {
  const _AuditPageHeader({required this.onNavigate});

  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 13, 14, 18),
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/panda_logo.png',
            width: 30,
            height: 35,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 7),
          const Expanded(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text.rich(
                TextSpan(
                  style: TextStyle(fontFamily: 'Gloock', fontSize: 21),
                  children: [
                    TextSpan(
                      text: 'Panda',
                      style: TextStyle(color: PandaColors.olive),
                    ),
                    TextSpan(
                      text: 'Crumbs',
                      style: TextStyle(color: PandaColors.terracotta),
                    ),
                  ],
                ),
              ),
            ),
          ),
          PopupMenuButton<int>(
            tooltip: 'Buka menu',
            onSelected: onNavigate,
            itemBuilder: (context) => const [
              PopupMenuItem(value: 0, child: Text('Pantry')),
              PopupMenuItem(value: 1, child: Text('Recipe')),
              PopupMenuItem(value: 2, child: Text('Waste Audit')),
              PopupMenuItem(value: 3, child: Text('Community')),
              PopupMenuItem(value: 4, child: Text('Habit')),
            ],
            child: Container(
              height: 35,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFE0E8D0),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Row(
                children: [
                  Text(
                    'Menu',
                    style: TextStyle(fontSize: 11, color: PandaColors.ink),
                  ),
                  SizedBox(width: 3),
                  Icon(Icons.menu_rounded, size: 14, color: PandaColors.ink),
                ],
              ),
            ),
          ),
          const SizedBox(width: 7),
          InkWell(
            customBorder: const CircleBorder(),
            onTap: () => showPandaMessage(
              context,
              'Fitur akun PandaCrumbs akan segera hadir.',
            ),
            child: const CircleAvatar(
              radius: 18,
              backgroundColor: Color(0xFFE0E8D0),
              child: Text(
                'D',
                style: TextStyle(
                  color: PandaColors.olive,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 13,
            color: PandaColors.ink,
          ),
        ],
      ),
    );
  }
}

class _AuditMetricCard extends StatelessWidget {
  const _AuditMetricCard({
    required this.colors,
    required this.icon,
    required this.title,
    required this.value,
    required this.caption,
    this.overline,
    this.valueSuffix,
    this.compactValue = false,
  });

  final List<Color> colors;
  final IconData icon;
  final String? overline;
  final String title;
  final String value;
  final String? valueSuffix;
  final String caption;
  final bool compactValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 14),
      padding: const EdgeInsets.fromLTRB(18, 17, 18, 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: colors.first.withValues(alpha: .7)),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1C594733),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: PandaColors.olive, size: 21),
              ),
              const Spacer(),
              if (overline != null)
                Text(
                  overline!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF756454),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF55463A),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          if (valueSuffix != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: PandaColors.oliveDark,
                    fontSize: 31,
                    height: 1,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 7),
                Text(
                  valueSuffix!,
                  style: const TextStyle(
                    color: Color(0xFF526246),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          else
            Text(
              value,
              style: TextStyle(
                color: PandaColors.ink,
                fontSize: compactValue ? 20 : 30,
                height: compactValue ? 1.2 : 1,
                fontWeight: FontWeight.w700,
                letterSpacing: compactValue ? -.35 : -.8,
              ),
            ),
          const SizedBox(height: 9),
          Text(
            caption,
            style: const TextStyle(
              color: Color(0xFF766A5E),
              fontSize: 11,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryPanel extends StatelessWidget {
  const _HistoryPanel({
    required this.records,
    required this.totalRecordCount,
    required this.dateFrom,
    required this.dateTo,
    required this.reason,
    required this.onDateFrom,
    required this.onDateTo,
    required this.onReasonChanged,
    required this.onApply,
    required this.onReset,
    required this.onEdit,
    required this.onDelete,
  });

  final List<WasteRecord> records;
  final int totalRecordCount;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String reason;
  final ValueChanged<DateTime?> onDateFrom;
  final ValueChanged<DateTime?> onDateTo;
  final ValueChanged<String> onReasonChanged;
  final VoidCallback onApply;
  final VoidCallback onReset;
  final ValueChanged<WasteRecord> onEdit;
  final ValueChanged<WasteRecord> onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 16, 14, 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF2E5),
        border: Border.all(color: const Color(0xFFDADFCF)),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1B493726),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(18, 19, 18, 18),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFEE9A76), Color(0xFFF6D68E)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Riwayat makanan\nterbuang',
                  style: TextStyle(
                    fontFamily: 'Gloock',
                    fontSize: 23,
                    height: 1.15,
                    color: PandaColors.ink,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Lihat kembali catatanmu atau cari berdasarkan tanggal dan alasan.',
                  style: TextStyle(
                    color: Color(0xFF66584C),
                    fontSize: 11.5,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE3ECD6),
                    borderRadius: BorderRadius.all(Radius.circular(18)),
                  ),
                  child: Text(
                    '${records.length} catatan',
                    style: const TextStyle(
                      color: PandaColors.oliveDark,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 17, 15, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _FilterDateField(
                  label: 'Dari tanggal',
                  value: dateFrom,
                  onChanged: onDateFrom,
                ),
                const SizedBox(height: 13),
                _FilterDateField(
                  label: 'Sampai tanggal',
                  value: dateTo,
                  onChanged: onDateTo,
                ),
                const SizedBox(height: 13),
                const Text(
                  'Alasan',
                  style: TextStyle(
                    fontSize: 10.5,
                    color: PandaColors.oliveDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: reason,
                  isExpanded: true,
                  items: ['Semua alasan', ..._WasteAuditScreenState._reasons]
                      .map((item) {
                        return DropdownMenuItem(value: item, child: Text(item));
                      })
                      .toList(),
                  onChanged: (value) {
                    if (value != null) onReasonChanged(value);
                  },
                  decoration: _auditInputDecoration(),
                  style: const TextStyle(fontSize: 12, color: PandaColors.ink),
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 9,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      onPressed: onApply,
                      icon: const Icon(Icons.tune_rounded, size: 15),
                      label: const Text('Terapkan'),
                      style: FilledButton.styleFrom(
                        backgroundColor: PandaColors.terracotta,
                        foregroundColor: PandaColors.ink,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 9,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: onReset,
                      icon: const Icon(Icons.refresh_rounded, size: 15),
                      label: const Text('Reset filter'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: PandaColors.oliveDark,
                        side: const BorderSide(color: Color(0xFF9BA88B)),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 13,
                          vertical: 9,
                        ),
                        textStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFD9DECD)),
          if (records.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 18, vertical: 28),
              child: Text(
                'Tidak ada catatan yang cocok dengan filter.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12, color: PandaColors.muted),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(13, 15, 13, 5),
              child: Column(
                children: [
                  for (final record in records)
                    _WasteRecordCard(
                      record: record,
                      onEdit: () => onEdit(record),
                      onDelete: () => onDelete(record),
                    ),
                ],
              ),
            ),
          if (records.isEmpty && totalRecordCount > 0)
            const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _FilterDateField extends StatelessWidget {
  const _FilterDateField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.5,
            color: PandaColors.oliveDark,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime(2026, 10, 27),
              firstDate: DateTime(2020),
              lastDate: DateTime(2035),
            );
            if (date != null) onChanged(date);
          },
          borderRadius: BorderRadius.circular(10),
          child: InputDecorator(
            decoration: _auditInputDecoration(),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value == null ? 'dd/mm/yyyy' : _formatDateNumeric(value!),
                    style: TextStyle(
                      fontSize: 12,
                      color: value == null
                          ? const Color(0xFF807B72)
                          : PandaColors.ink,
                    ),
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  size: 14,
                  color: PandaColors.ink,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _WasteRecordCard extends StatelessWidget {
  const _WasteRecordCard({
    required this.record,
    required this.onEdit,
    required this.onDelete,
  });

  final WasteRecord record;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(15, 14, 15, 13),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFD4DCC8)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            record.name,
            style: const TextStyle(
              color: PandaColors.ink,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFE0E5D9)),
          ),
          _RecordDetailRow('Jumlah', '${record.quantity} ${record.unit}'),
          _RecordDetailRow('Tanggal', _formatDateShort(record.date)),
          const SizedBox(height: 9),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Alasan',
                  style: TextStyle(
                    color: PandaColors.olive,
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: _reasonColor(record.reason),
                  borderRadius: BorderRadius.circular(7),
                ),
                child: Text(
                  record.reason,
                  style: const TextStyle(
                    color: Color(0xFF5B5144),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          _RecordDetailRow(
            'Kerugian',
            record.loss == null
                ? 'Belum diisi'
                : 'Rp${_formatMoney(record.loss!)}',
            valueStrong: record.loss != null,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFE0E5D9)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 13),
                label: const Text('Ubah'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: PandaColors.oliveDark,
                  side: const BorderSide(color: Color(0xFF9AA78A)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline_rounded, size: 13),
                label: const Text('Hapus'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: PandaColors.terracottaDark,
                  side: const BorderSide(color: Color(0xFFE5AE9C)),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 11,
                    vertical: 7,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textStyle: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecordDetailRow extends StatelessWidget {
  const _RecordDetailRow(this.label, this.value, {this.valueStrong = false});

  final String label;
  final String value;
  final bool valueStrong;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                color: PandaColors.olive,
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueStrong
                  ? PandaColors.oliveDark
                  : const Color(0xFF77766D),
              fontSize: 10.5,
              fontWeight: valueStrong ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class AddWasteNoteForm extends StatefulWidget {
  const AddWasteNoteForm({
    super.key,
    required this.initialRecord,
    required this.onCancel,
    required this.onSave,
  });

  final WasteRecord? initialRecord;
  final VoidCallback onCancel;
  final ValueChanged<WasteRecord> onSave;

  @override
  State<AddWasteNoteForm> createState() => _AddWasteNoteFormState();
}

class _AddWasteNoteFormState extends State<AddWasteNoteForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _quantityController;
  late final TextEditingController _lossController;
  late DateTime _date;
  String? _unit;
  String? _reason;
  bool _referenceExpanded = false;

  static const _units = <String>[
    'porsi',
    'buah',
    'gram',
    'kg',
    'ml',
    'liter',
    'ikat',
    'lembar',
    'papan',
    'pcs',
  ];

  static const _reasons = <String>[
    'Rusak atau basi',
    'Kedaluwarsa',
    'Porsi berlebih',
    'Terlalu matang',
    'Lainnya',
  ];

  @override
  void initState() {
    super.initState();
    final record = widget.initialRecord;
    _nameController = TextEditingController(text: record?.name ?? '');
    _quantityController = TextEditingController(text: record?.quantity ?? '');
    _lossController = TextEditingController(
      text: record?.loss?.toString() ?? '',
    );
    _unit = record?.unit;
    _reason = record?.reason;
    _date = record?.date ?? DateTime(2026, 10, 27);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _lossController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.fromLTRB(19, 24, 19, 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFEFB),
        border: Border.all(color: const Color(0xFFD1D3C5)),
        borderRadius: BorderRadius.circular(21),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D493726),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Food Waste Audit',
              style: TextStyle(
                color: PandaColors.oliveDark,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.initialRecord == null ? 'Tambah catatan' : 'Ubah catatan',
              style: const TextStyle(
                fontFamily: 'Gloock',
                fontSize: 34,
                height: 1.1,
                letterSpacing: -.5,
                color: PandaColors.ink,
              ),
            ),
            const SizedBox(height: 13),
            const Text(
              'Apa yang terbuang dari dapurmu hari ini?',
              style: TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Color(0xFF68695F),
              ),
            ),
            const SizedBox(height: 22),
            const Text(
              'Kolom bertanda * wajib diisi.',
              style: TextStyle(fontSize: 11.5, color: Color(0xFF77766D)),
            ),
            const _AuditFormDivider(),
            const _AuditFormSectionTitle('Makanan yang terbuang'),
            const SizedBox(height: 6),
            const _AuditFieldLabel('Nama makanan'),
            const SizedBox(height: 7),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.sentences,
              decoration: _auditInputDecoration(hintText: 'Contoh: nasi putih'),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Nama makanan wajib diisi.'
                  : null,
            ),
            const SizedBox(height: 17),
            _buildPackagingReference(),
            const SizedBox(height: 21),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _AuditFieldLabel('Jumlah terbuang'),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: _quantityController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: _auditInputDecoration(hintText: ''),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? 'Jumlah wajib diisi.'
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _AuditFieldLabel('Satuan'),
                      const SizedBox(height: 7),
                      DropdownButtonFormField<String>(
                        initialValue: _unit,
                        isExpanded: true,
                        items: _units
                            .map(
                              (unit) => DropdownMenuItem(
                                value: unit,
                                child: Text(unit),
                              ),
                            )
                            .toList(),
                        onChanged: (value) => setState(() => _unit = value),
                        validator: (value) =>
                            value == null ? 'Pilih satuan.' : null,
                        decoration: _auditInputDecoration(
                          hintText: '---------',
                        ),
                        style: const TextStyle(
                          fontSize: 12,
                          color: PandaColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const _AuditFormDivider(),
            const _AuditFormSectionTitle('Waktu & alasan'),
            const SizedBox(height: 7),
            const _AuditFieldLabel('Tanggal terbuang'),
            const SizedBox(height: 7),
            _FormDateField(
              value: _date,
              onChanged: (date) => setState(() => _date = date),
            ),
            const SizedBox(height: 19),
            const _AuditFieldLabel('Alasan'),
            const SizedBox(height: 7),
            DropdownButtonFormField<String>(
              initialValue: _reason,
              isExpanded: true,
              items: _reasons
                  .map(
                    (reason) =>
                        DropdownMenuItem(value: reason, child: Text(reason)),
                  )
                  .toList(),
              onChanged: (value) => setState(() => _reason = value),
              validator: (value) => value == null ? 'Pilih alasan.' : null,
              decoration: _auditInputDecoration(hintText: '---------'),
              style: const TextStyle(fontSize: 12, color: PandaColors.ink),
            ),
            const _AuditFormDivider(),
            const _AuditFormSectionTitle('Perkiraan kerugian'),
            const SizedBox(height: 7),
            const Row(
              children: [
                Expanded(
                  child: _AuditFieldLabel(
                    'Nilai makanan yang terbuang',
                    required: false,
                  ),
                ),
                Text(
                  'opsional',
                  style: TextStyle(fontSize: 10.5, color: PandaColors.muted),
                ),
              ],
            ),
            const SizedBox(height: 7),
            TextFormField(
              controller: _lossController,
              keyboardType: TextInputType.number,
              decoration: _auditInputDecoration(
                hintText: 'Contoh: 5000',
                prefixText: 'Rp  ',
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) return null;
                final amount = int.tryParse(
                  value.replaceAll('.', '').replaceAll(',', ''),
                );
                return amount == null || amount < 0
                    ? 'Masukkan angka yang valid.'
                    : null;
              },
            ),
            const SizedBox(height: 9),
            const Text(
              'Total nilai makanan yang terbuang pada catatan ini, bukan harga per satuan. Kosongkan jika belum tahu.',
              style: TextStyle(
                color: Color(0xFF77766D),
                fontSize: 11.5,
                height: 1.55,
              ),
            ),
            const _AuditFormDivider(),
            Row(
              children: [
                OutlinedButton(
                  onPressed: widget.onCancel,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: PandaColors.oliveDark,
                    side: const BorderSide(color: Color(0xFF9AA78A)),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 17,
                      vertical: 11,
                    ),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text('Batal', style: TextStyle(fontSize: 12)),
                ),
                const Spacer(),
                FilledButton.icon(
                  onPressed: _submit,
                  icon: const Icon(Icons.check_rounded, size: 17),
                  label: Text(
                    widget.initialRecord == null
                        ? 'Simpan catatan'
                        : 'Simpan perubahan',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: PandaColors.terracotta,
                    foregroundColor: PandaColors.ink,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 17,
                      vertical: 12,
                    ),
                    shape: const StadiumBorder(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPackagingReference() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEEF3E5),
        border: Border.all(color: const Color(0xFFC4D0B3)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () =>
                setState(() => _referenceExpanded = !_referenceExpanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 19),
              child: Row(
                children: [
                  Icon(
                    _referenceExpanded
                        ? Icons.arrow_drop_down
                        : Icons.arrow_right,
                    color: PandaColors.oliveDark,
                    size: 17,
                  ),
                  const SizedBox(width: 7),
                  const Expanded(
                    child: Text(
                      'Cari referensi bahan kemasan',
                      style: TextStyle(
                        color: PandaColors.oliveDark,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_referenceExpanded)
            const Padding(
              padding: EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Masukkan nama atau kode yang tercetak pada kemasan.',
                    style: TextStyle(fontSize: 11, color: PandaColors.muted),
                  ),
                  SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari bahan makanan',
                      isDense: true,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(9)),
                        borderSide: BorderSide(color: Color(0xFF9AA78A)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate() ||
        _unit == null ||
        _reason == null) {
      return;
    }
    final rawAmount = _lossController.text.trim();
    final loss = rawAmount.isEmpty
        ? null
        : int.parse(rawAmount.replaceAll('.', '').replaceAll(',', ''));
    final previous = widget.initialRecord;
    final generatedId = DateTime.now().microsecondsSinceEpoch;
    widget.onSave(
      WasteRecord(
        id: previous?.id ?? generatedId,
        name: _nameController.text.trim(),
        quantity: _quantityController.text.trim().replaceAll('.', ','),
        unit: _unit!,
        date: _date,
        reason: _reason!,
        loss: loss,
      ),
    );
  }
}

class _AuditFormSectionTitle extends StatelessWidget {
  const _AuditFormSectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        color: PandaColors.oliveDark,
        fontSize: 15.5,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _AuditFieldLabel extends StatelessWidget {
  const _AuditFieldLabel(this.label, {this.required = true});

  final String label;
  final bool required;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: PandaColors.oliveDark,
          fontFamily: 'Inter',
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        children: [
          TextSpan(text: label),
          if (required)
            const TextSpan(
              text: ' *',
              style: TextStyle(color: PandaColors.terracottaDark),
            ),
        ],
      ),
    );
  }
}

class _AuditFormDivider extends StatelessWidget {
  const _AuditFormDivider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 23),
      child: Divider(height: 1, color: Color(0xFFD6D9C9)),
    );
  }
}

class _FormDateField extends StatelessWidget {
  const _FormDateField({required this.value, required this.onChanged});

  final DateTime value;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime(2020),
          lastDate: DateTime(2035),
        );
        if (picked != null) onChanged(picked);
      },
      borderRadius: BorderRadius.circular(11),
      child: InputDecorator(
        decoration: _auditInputDecoration(),
        child: Row(
          children: [
            Expanded(
              child: Text(
                _formatDateNumeric(value),
                style: const TextStyle(fontSize: 13, color: PandaColors.ink),
              ),
            ),
            const Icon(
              Icons.calendar_today_outlined,
              size: 16,
              color: PandaColors.ink,
            ),
          ],
        ),
      ),
    );
  }
}

class _AuditFooter extends StatelessWidget {
  const _AuditFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 4),
      padding: const EdgeInsets.only(top: 20, bottom: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFE3DFD3))),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 25,
            top: 0,
            child: Opacity(
              opacity: .09,
              child: Image.asset(
                'assets/images/panda_logo.png',
                width: 54,
                height: 54,
              ),
            ),
          ),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PandaCrumbs · Mulai dari dapurmu.',
                style: TextStyle(color: Color(0xFF766458), fontSize: 10),
              ),
              SizedBox(height: 12),
              Text(
                'Proyek PBP · Kelompok F4',
                style: TextStyle(color: Color(0xFF766458), fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

InputDecoration _auditInputDecoration({String? hintText, String? prefixText}) {
  const outline = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(11)),
    borderSide: BorderSide(color: Color(0xFF97A287), width: 1),
  );
  return InputDecoration(
    hintText: hintText,
    prefixText: prefixText,
    isDense: true,
    filled: true,
    fillColor: Colors.white,
    contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 13),
    border: outline,
    enabledBorder: outline,
    focusedBorder: outline.copyWith(
      borderSide: const BorderSide(color: PandaColors.olive, width: 1.4),
    ),
    errorBorder: outline.copyWith(
      borderSide: const BorderSide(color: PandaColors.terracotta, width: 1.2),
    ),
    focusedErrorBorder: outline.copyWith(
      borderSide: const BorderSide(color: PandaColors.terracotta, width: 1.4),
    ),
    hintStyle: const TextStyle(color: Color(0xFF807B72), fontSize: 12.5),
    prefixStyle: const TextStyle(
      color: PandaColors.oliveDark,
      fontSize: 12,
      fontWeight: FontWeight.w700,
    ),
  );
}

Color _reasonColor(String reason) {
  switch (reason) {
    case 'Porsi berlebih':
      return const Color(0xFFFFDF70);
    case 'Kedaluwarsa':
      return const Color(0xFFFFC6A8);
    case 'Rusak atau basi':
      return const Color(0xFFEACBD0);
    case 'Terlalu matang':
      return const Color(0xFFDCE8C8);
    default:
      return const Color(0xFFE8E4D8);
  }
}

String _formatMoney(int amount) {
  final digits = amount.toString();
  final result = StringBuffer();
  for (var index = 0; index < digits.length; index++) {
    if (index > 0 && (digits.length - index) % 3 == 0) result.write('.');
    result.write(digits[index]);
  }
  return result.toString();
}

String _formatDateNumeric(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}

String _formatDateShort(DateTime date) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];
  return '${date.day} ${months[date.month - 1]} ${date.year}';
}
