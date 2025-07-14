// src/pages/PendingDriverListPage.js

import React, { useState } from 'react';
import Sidebar from '../components/Sidebar';
import { useNavigate } from 'react-router-dom';
import './PendingDriverListPage.css';

const dummyPendingDrivers = [
    {
        id: 'P01',
        name: '최기사',
        carType: '1톤 카고',
        phone: '010-9999-8888',
        createdAt: '2025.07.12',
        status: 'PENDING',
    },
    {
        id: 'P02',
        name: '박기사',
        carType: '2.5톤 리프트',
        phone: '010-5555-4444',
        createdAt: '2025.07.13',
        status: 'PENDING',
    },
];

function PendingDriverListPage() {
    const [drivers] = useState(dummyPendingDrivers);
    const navigate = useNavigate();

    return (
        <div className="pending-driver-page-bg">
            <div style={{ display: 'flex', minHeight: '100vh' }}>
                
                <div className="pending-driver-container">
                    <h2 className="pending-driver-title">기사님 요청 목록</h2>
                    <div className="pending-driver-table-wrapper">
                        <table className="pending-driver-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>이름</th>
                                    <th>차량</th>
                                    <th>전화번호</th>
                                    <th>등록일</th>
                                    <th>상태</th>
                                    <th>상세</th>
                                    <th>승인</th>
                                    <th>거절</th>
                                </tr>
                            </thead>
                            <tbody>
                                {drivers.map(d => (
                                    <tr key={d.id}>
                                        <td>{d.id}</td>
                                        <td>{d.name}</td>
                                        <td>{d.carType}</td>
                                        <td>{d.phone}</td>
                                        <td>{d.createdAt}</td>
                                        <td>
                                            <span className="pending-badge pending-badge-pending">
                                                미승인
                                            </span>
                                        </td>
                                        <td>
                                            <button
                                                className="pending-detail-btn"
                                                onClick={() => navigate(`/drivers/pending/${d.id}`)}
                                            >
                                                상세
                                            </button>
                                        </td>
                                        <td>
                                            <button className="pending-approve-btn">
                                                승인
                                            </button>
                                        </td>
                                        <td>
                                            <button className="pending-reject-btn">
                                                거절
                                            </button>
                                        </td>
                                    </tr>
                                ))}
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    );
}

export default PendingDriverListPage;
