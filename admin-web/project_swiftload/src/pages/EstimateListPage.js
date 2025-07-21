// src/pages/EstimateListPage.js

import React, { useEffect, useState } from 'react';
import Sidebar from '../components/Sidebar';
import StatusBadge from '../components/StatusBadge';
import { useNavigate } from 'react-router-dom';
import './EstimateListPage.css';
import DetailModal from '../components/DetailModal';
import { collection, getDocs } from 'firebase/firestore';
import { db } from '../firebase';

function EstimateListPage() {
  const [estimates, setEstimates] = useState([]);
  const [modalOpen, setModalOpen] = useState(false);
  const [selectedEstimate, setSelectedEstimate] = useState(null);

  // Firestore에서 데이터 불러오기
  useEffect(() => {
    async function fetchEstimates() {
      const snapshot = await getDocs(collection(db, "estimates"));
      const data = snapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data()
      }));
      setEstimates(data);
    }
    fetchEstimates();
  }, []);

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
                  <th>출발지</th>
                  <th>도착지</th>
                  <th>상차일시</th>
                  <th>차종</th>
                  <th>톤수</th>
                  <th>상세</th>
                </tr>
              </thead>
              <tbody>
                {estimates.map(e => (
                  <tr key={e.id}>
                    <td>{e.id.slice(0, 6)}</td>
                    <td>{e.departureAddress}</td>
                    <td>{e.arrivalAddress}</td>
                    <td>
                      {e.pickupDateTimeOption}
                      <br />
                      {/* Firestore timestamp 처리 */}
                      {e.pickupDateTime?.toDate 
                        ? e.pickupDateTime.toDate().toLocaleString()
                        : (e.pickupDateTime || '-')}
                    </td>
                    <td>{e.selectedCarType}</td>
                    <td>{e.selectedTon}</td>
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
