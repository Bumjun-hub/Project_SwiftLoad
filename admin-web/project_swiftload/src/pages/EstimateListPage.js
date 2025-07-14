// src/pages/EstimateListPage.js

import React, { useState } from 'react';
import Sidebar from '../components/Sidebar';
import StatusBadge from '../components/StatusBadge';
import { useNavigate } from 'react-router-dom';
import './EstimateListPage.css';
import DetailModal from '../components/DetailModal';

const dummyEstimates = [
    {
        id: '01',
        shipper: '범준',
        car: '차량1',
        loadTime: '2025.07.14 오후 1시',
        status: 'OPEN',
        matchedDriver: 'X',
    },
    {
        id: '02',
        shipper: '태형',
        car: '차량2',
        loadTime: '2025.07.14 오후 1시',
        status: 'MATCHED',
        matchedDriver: '범준',
    }
];

function EstimateListPage() {
    const [estimates] = useState(dummyEstimates);
    const [modalOpen, setModalOpen] = useState(false);
    const [selectedEstimate, setSelectedEstimate] = useState(null);
  const handleDetailClick = (estimate) => {
    setSelectedEstimate(estimate);
    setModalOpen(true);
  };
    
    return (
        <div className="estimate-page-bg">
            <div style={{ display: 'flex', minHeight: '100vh' }}>
                
                <div className="estimate-container">
                    <h2 className="estimate-title">견적 관리</h2>
                    <div className="estimate-table-wrapper">
                        <table className="estimate-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>화주</th>
                                    <th>차량</th>
                                    <th>상차 시간</th>
                                    <th>매칭 상태</th>
                                    <th>매칭 기사</th>
                                    <th>상세</th>
                                </tr>
                            </thead>
                            <tbody>
                                {estimates.map(e => (
                                    <tr key={e.id}>
                                        <td>{e.id}</td>
                                        <td>{e.shipper}</td>
                                        <td>{e.car}</td>
                                        <td>{e.loadTime}</td>
                                        <td><StatusBadge status={e.status} /></td>
                                        <td>{e.matchedDriver}</td>
                                        <td>
                                            <button
                                                className="estimate-detail-btn"
                                                onClick={() => handleDetailClick(e)}
                                            >
                                                상세
                                            </button>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                </div>
                <DetailModal
                    open={modalOpen}
                    onClose={() => setModalOpen(false)}
                    estimate={selectedEstimate}
                />
            </div>
        </div>
    );
}

export default EstimateListPage;
