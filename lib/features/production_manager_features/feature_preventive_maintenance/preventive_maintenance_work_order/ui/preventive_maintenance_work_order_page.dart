// import 'package:easy_ops/features/feature_preventive_maintenance/preventive_maintenance_work_order/controller/preventive_maintenance_work_order_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// /* ---------------------- THEME ---------------------- */
// class _C {
//   static const primary = Color(0xFF2F6BFF);
//   static const surface = Colors.white;
//   static const bg = Color(0xFFF6F7FB);
//   static const text = Color(0xFF1F2430);
//   static const muted = Color(0xFF6B7280);
//   static const border = Color(0xFFE9EEF5);
//   static const danger = Color(0xFFE53935);
// }

// class PreventiveMaintenancePage
//     extends GetView<PreventiveMaintenanceWorkOrderController> {
//   const PreventiveMaintenancePage({super.key});
//   @override
//   PreventiveMaintenanceWorkOrderController get controller =>
//       Get.put(PreventiveMaintenanceWorkOrderController());

//   bool _isTablet(BuildContext c) => MediaQuery.of(c).size.shortestSide >= 600;

//   @override
//   Widget build(BuildContext context) {
//     final isTablet = _isTablet(context);
//     final hPad = isTablet ? 20.0 : 16.0;
//     final vGap = isTablet ? 14.0 : 12.0;

//     return Scaffold(
//       backgroundColor: _C.bg,
//       appBar: AppBar(
//         backgroundColor: _C.primary,
//         elevation: 0,
//         automaticallyImplyLeading: true,
//         title: const Text(
//           'Preventive Maintenance',
//           style: TextStyle(fontWeight: FontWeight.w700),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(56),
//           child: Container(
//             color: _C.primary,
//             child: Align(
//               alignment: Alignment.centerLeft,
//               child: TabBar(
//                 controller: controller.tab,
//                 isScrollable: true,
//                 indicatorColor: Colors.white,
//                 indicatorWeight: 3,
//                 labelPadding: const EdgeInsets.symmetric(horizontal: 18),
//                 tabs: const [
//                   Tab(text: 'Work Order'),
//                   Tab(text: 'History'),
//                   Tab(text: 'M/C Info'),
//                 ],
//                 labelStyle: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.w700,
//                 ),
//                 unselectedLabelStyle: const TextStyle(fontSize: 15),
//                 labelColor: Colors.white,
//                 unselectedLabelColor: Colors.white70,
//               ),
//             ),
//           ),
//         ),
//       ),
//       body: TabBarView(
//         controller: controller.tab,
//         children: [
//           _WorkOrderTab(hPad: hPad, vGap: vGap),
//           _HistoryTab(hPad: hPad, vGap: vGap),
//           _McInfoTab(hPad: hPad, vGap: vGap),
//         ],
//       ),
//     );
//   }
// }

// /* ---------------------- TAB: WORK ORDER ---------------------- */
// class _WorkOrderTab extends GetView<PreventiveMaintenanceWorkOrderController> {
//   final double hPad;
//   final double vGap;
//   const _WorkOrderTab({required this.hPad, required this.vGap});

//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: EdgeInsets.fromLTRB(hPad, vGap, hPad, vGap + 8),
//       child: Column(
//         children: [
// // PM Schedule
//           Obx(() => _SectionCard(
//                 title: 'PM Schedule',
//                 open: controller.pmScheduleOpen.value,
//                 onToggle: () => controller.toggle(controller.pmScheduleOpen),
//                 child: _PmScheduleBlock(),
//               )),
//           SizedBox(height: vGap),

// // Additional Pending Activity
//           Obx(() => _SectionCard(
//                 title: 'Additional Pending Activity',
//                 subtitle: '${controller.pendingActivityCount.value} Identified',
//                 open: controller.pendingActivityOpen.value,
//                 onToggle: () =>
//                     controller.toggle(controller.pendingActivityOpen),
//                 child: _PendingActivityBlock(),
//               )),
//           SizedBox(height: vGap),

// // Manufacture Contact Info
//           Obx(() => _SectionCard(
//                 title: 'Manufacture Contact Info',
//                 open: controller.mfgContactOpen.value,
//                 onToggle: () => controller.toggle(controller.mfgContactOpen),
//                 child: _ManufacturerBlock(),
//               )),
//           SizedBox(height: vGap),

// // Assets History
//           Obx(() => _SectionCard(
//                 title: 'Assets History',
//                 open: controller.assetsHistoryOpen.value,
//                 onToggle: () => controller.toggle(controller.assetsHistoryOpen),
//                 child: _AssetHistoryBlock(),
//               )),
//           SizedBox(height: vGap),

// // Assets Master
//           Obx(() => _SectionCard(
//                 title: 'Assets Master',
//                 open: controller.assetsMasterOpen.value,
//                 onToggle: () => controller.toggle(controller.assetsMasterOpen),
//                 child: _AssetMasterBlock(),
//               )),
//           SizedBox(height: vGap),

// // Dashboard
//           Obx(() => _SectionCard(
//                 title: 'Dashboard',
//                 open: controller.dashboardOpen.value,
//                 onToggle: () => controller.toggle(controller.dashboardOpen),
//                 child: _DashboardBlock(),
//               )),
//         ],
//       ),
//     );
//   }
// }

// /* ---------------------- TAB: HISTORY (placeholder) ---------------------- */
// class _HistoryTab extends StatelessWidget {
//   final double hPad;
//   final double vGap;
//   const _HistoryTab({required this.hPad, required this.vGap});
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(hPad),
//         child: const Text(
//           'History coming soon…',
//           style: TextStyle(color: _C.muted),
//         ),
//       ),
//     );
//   }
// }

// /* ---------------------- TAB: M/C INFO (placeholder) ---------------------- */
// class _McInfoTab extends StatelessWidget {
//   final double hPad;
//   final double vGap;
//   const _McInfoTab({required this.hPad, required this.vGap});
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Padding(
//         padding: EdgeInsets.all(hPad),
//         child: const Text(
//           'Machine info coming soon…',
//           style: TextStyle(color: _C.muted),
//         ),
//       ),
//     );
//   }
// }

// /* ---------------------- BLOCKS ---------------------- */
// class _PmScheduleBlock
//     extends GetView<PreventiveMaintenanceWorkOrderController> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: const [
//             Expanded(
//               child: Text('Preventive',
//                   style: TextStyle(
//                       fontSize: 12,
//                       color: _C.muted,
//                       fontWeight: FontWeight.w600)),
//             ),
//             Text('Pending',
//                 style: TextStyle(
//                     fontSize: 12,
//                     color: _C.muted,
//                     fontWeight: FontWeight.w600)),
//           ],
//         ),
//         const SizedBox(height: 6),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Obx(() => Text(
//                     controller.maintenanceType.value,
//                     style: const TextStyle(
//                       fontSize: 15,
//                       fontWeight: FontWeight.w700,
//                       height: 1.25,
//                     ),
//                   )),
//             ),
//             const SizedBox(width: 8),
//             Obx(() => Text(
//                   controller.requiredHrs.value,
//                   style: const TextStyle(
//                     fontSize: 13,
//                     color: _C.text,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 )),
//           ],
//         ),
//         const SizedBox(height: 8),
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Obx(() => Text(
//                   controller.dueDateText.value,
//                   style: const TextStyle(fontSize: 13, color: _C.text),
//                 )),
//             TextButton(
//               onPressed: () {},
//               child: const Text('Propose New',
//                   style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }

// class _PendingActivityBlock extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         _MutedText('2 activities identified during last PM:'),
//         SizedBox(height: 8),
//         _Bullet('Investigate coolant leakage near spindle'),
//         _Bullet('Replace worn-out belt – vibration observed'),
//       ],
//     );
//   }
// }

// class _ManufacturerBlock extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         _RowKV('OEM', 'Siemens'),
//         SizedBox(height: 6),
//         _RowKV('Support', '+91 98XXXXXX90'),
//         SizedBox(height: 6),
//         _RowKV('Email', 'support@siemens.example'),
//       ],
//     );
//   }
// }

// class _AssetHistoryBlock extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         _RowKV('Last PM', '15 Sep 2024'),
//         SizedBox(height: 6),
//         _RowKV('Breakdowns (YTD)', '3'),
//         SizedBox(height: 6),
//         _RowKV('Avg. MTTR', '2h 10m'),
//       ],
//     );
//   }
// }

// class _AssetMasterBlock
//     extends GetView<PreventiveMaintenanceWorkOrderController> {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     '${controller.assetName} | ${controller.assetBrand}',
//                     style: const TextStyle(
//                         fontSize: 16, fontWeight: FontWeight.w700),
//                   ),
//                   const SizedBox(height: 6),
//                   Text(
//                     controller.assetDesc,
//                     style: const TextStyle(
//                         fontSize: 13, color: _C.text, height: 1.35),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),
//             Obx(() => _Pill(
//                   text: controller.critical.value ? 'Critical' : 'Normal',
//                   bg: controller.critical.value
//                       ? _C.danger.withOpacity(.1)
//                       : const Color(0xFF16A34A).withOpacity(.1),
//                   fg: controller.critical.value
//                       ? _C.danger
//                       : const Color(0xFF166534),
//                 )),
//           ],
//         ),
//         const SizedBox(height: 10),
//         const _MutedText('Working'),
//         const SizedBox(height: 6),
//         Align(
//           alignment: Alignment.centerRight,
//           child: TextButton(
//             onPressed: () {},
//             child: const Text('View More',
//                 style: TextStyle(fontWeight: FontWeight.w600)),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class _DashboardBlock extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: const [
//         _RowKV('Uptime (30d)', '96.4%'),
//         SizedBox(height: 6),
//         _RowKV('Planned vs Actual PM', '88%'),
//       ],
//     );
//   }
// }

// /* ---------------------- GENERIC WIDGETS ---------------------- */
// class _SectionCard extends StatelessWidget {
//   final String title;
//   final String? subtitle;
//   final bool open;
//   final VoidCallback onToggle;
//   final Widget child;
//   const _SectionCard({
//     required this.title,
//     required this.open,
//     required this.onToggle,
//     required this.child,
//     this.subtitle,
//     super.key,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 200),
//       curve: Curves.easeOut,
//       decoration: BoxDecoration(
//         color: _C.surface,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           )
//         ],
//       ),
//       child: Column(
//         children: [
//           InkWell(
//             onTap: onToggle,
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//               child: Row(
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           title,
//                           style: const TextStyle(
//                             fontSize: 15,
//                             fontWeight: FontWeight.w800,
//                             color: _C.text,
//                           ),
//                         ),
//                         if (subtitle != null) ...[
//                           const SizedBox(height: 2),
//                           Text(subtitle!,
//                               style: const TextStyle(
//                                   fontSize: 12, color: _C.muted)),
//                         ],
//                       ],
//                     ),
//                   ),
//                   AnimatedRotation(
//                     turns: open ? 0.0 : 0.5,
//                     duration: const Duration(milliseconds: 200),
//                     child:
//                         const Icon(Icons.expand_less_rounded, color: _C.muted),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (open) const Divider(height: 1, thickness: 1, color: _C.border),
//           if (open)
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
//               child: child,
//             ),
//         ],
//       ),
//     );
//   }
// }

// class _RowKV extends StatelessWidget {
//   final String k;
//   final String v;
//   const _RowKV(this.k, this.v);
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         SizedBox(
//           width: 140,
//           child: Text(
//             k,
//             style: const TextStyle(
//                 fontSize: 13, color: _C.muted, fontWeight: FontWeight.w600),
//           ),
//         ),
//         Expanded(
//           child: Text(
//             v,
//             style: const TextStyle(fontSize: 13, color: _C.text),
//           ),
//         ),
//       ],
//     );
//   }
// }
