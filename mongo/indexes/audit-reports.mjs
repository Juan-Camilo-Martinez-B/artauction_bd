/** Índices de audit_reports. summaryId apunta al resumen de Postgres y es único. */
export const auditReportIndexSpecs = [
  {
    key: { lotId: 1, createdAt: -1 },
    name: 'audit_reports_lot_created',
  },
  {
    key: { summaryId: 1 },
    name: 'audit_reports_summary_id',
    unique: true,
  },
];
