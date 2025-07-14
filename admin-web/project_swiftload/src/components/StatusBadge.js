// src/components/StatusBadge.js
import React from 'react';

function StatusBadge({ status }) {
  const colors = {
    OPEN: 'green',
    MATCHED: 'red',
    DONE: 'gray',
  };
  const labels = {
    OPEN: 'OPEN',
    MATCHED: 'Match',
    DONE: 'Done',
  };
  return (
    <span style={{
      backgroundColor: colors[status] || '#ddd',
      color: '#fff',
      borderRadius: '8px',
      padding: '2px 12px',
      fontWeight: 'bold'
    }}>
      {labels[status] || status}
    </span>
  );
}

export default StatusBadge;
