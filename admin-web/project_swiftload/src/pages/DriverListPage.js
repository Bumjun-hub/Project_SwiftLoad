import React, { useState } from 'react';
import Sidebar from '../components/Sidebar';
import DriverDetailModal from '../components/DriverDetailModal';
import './DriverListPage.css';

const dummyDrivers = [
    {
        id: 'D01',
        name: '김기사',
        carType: '2.5톤 윙바디',
        phone: '010-1111-2222',
        approvedAt: '2025.07.14',
        status: 'APPROVED',
    },
    {
        id: 'D02',
        name: '이기사',
        carType: '1톤 카고',
        phone: '010-3333-4444',
        approvedAt: '2025.07.13',
        status: 'APPROVED',
    },
];

function DriverListPage() {
    const [drivers] = useState(dummyDrivers);
    const [modalOpen, setModalOpen] = useState(false);
    const [selectedDriver, setSelectedDriver] = useState(null);

    const handleDetailClick = (driver) => {
        setSelectedDriver(driver);
        setModalOpen(true);
    };

    return (
        <div className="driver-page-bg">
            <div style={{ display: 'flex', minHeight: '100vh' }}>
                
                <div className="driver-container">
                    <h2 className="driver-title">차주 관리</h2>
                    <div className="driver-table-wrapper">
                        <table className="driver-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>이름</th>
                                    <th>차량</th>
                                    <th>전화번호</th>
                                    <th>승인일시</th>
                                    <th>상태</th>
                                    <th>상세</th>
                                </tr>
                            </thead>
                            <tbody>
                                {drivers.map(d => (
                                    <tr key={d.id}>
                                        <td>{d.id}</td>
                                        <td>{d.name}</td>
                                        <td>{d.carType}</td>
                                        <td>{d.phone}</td>
                                        <td>{d.approvedAt}</td>
                                        <td>
                                            <span className="driver-badge driver-badge-approved">
                                                승인됨
                                            </span>
                                        </td>
                                        <td>
                                            <button
                                                className="driver-detail-btn"
                                                onClick={() => handleDetailClick(d)}
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
                <DriverDetailModal
                  open={modalOpen}
                  onClose={() => setModalOpen(false)}
                  driver={selectedDriver}
                />
            </div>
        </div>
    );
}

export default DriverListPage;
