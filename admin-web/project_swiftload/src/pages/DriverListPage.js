import React, { useEffect, useState } from 'react';
import { collection, getDocs } from "firebase/firestore";
import { db } from '../firebase';
import Sidebar from '../components/Sidebar';
import './DriverListPage.css';

function DriverListPage() {
  const [drivers, setDrivers] = useState([]);

  useEffect(() => {
    async function fetchDrivers() {
      const querySnapshot = await getDocs(collection(db, "drivers"));
      const data = querySnapshot.docs.map(doc => ({
        id: doc.id,
        ...doc.data()
      }));
      setDrivers(data);
    }
    fetchDrivers();
  }, []);

  return (
    <div style={{ display: 'flex', height: '100vh' }}>
      
      <div style={{ flex: 1, padding: '32px' }}>
        <h2>차주 관리</h2>
        <table className="driver-table">
          <thead>
            <tr>
              <th>이름</th>
              <th>전화번호</th>
              <th>차종</th>
              <th>차량번호</th>
              <th>톤수</th>
              <th>약관동의</th>
              <th>생성일</th>
            </tr>
          </thead>
          <tbody>
            {drivers.map(driver => (
              <tr key={driver.id}>
                <td>{driver.name}</td>
                <td>{driver.phone}</td>
                <td>{driver.vehicleType}</td>
                <td>{driver.vehicleNumber}</td>
                <td>{driver.vehicleSize}</td>
                <td>{driver.pledgeAgreed ? "O" : "X"}</td>
                <td>{driver.createdAt ? driver.createdAt.toString() : "-"}</td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
export default DriverListPage;
