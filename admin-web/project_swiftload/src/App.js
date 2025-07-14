import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import EstimateListPage from './pages/EstimateListPage';
import DriverListPage from './pages/DriverListPage';
import PendingDriverListPage from './pages/PendingDriverListPage';
import Header from './components/Header';
import Sidebar from './components/Sidebar';
import { useState } from 'react';
// import EstimateDetailPage from './pages/EstimateDetailPage';

function App() {
  const [sidebarOpen, setSidebarOpen] = useState(true);
  const handleSidebarToggle = () => setSidebarOpen(v => !v);

  return (
    <Router>
      <Header onSidebarToggle={handleSidebarToggle} />
      <div style={{ display: 'flex' }}>
         <Sidebar open={sidebarOpen} />
        <div style={{ flex: 1 }}>
          <Routes>
            {/* 견적 관리 - 리스트 */}
            <Route path="/" element={<EstimateListPage />} />
            {/* 견적 상세 */}
            {/* <Route path="/estimates/:estimateId" element={<EstimateDetailPage />} /> */}
            {/* 차주 관리 */}
            <Route path="/drivers" element={<DriverListPage />} />
            {/* 기사님 요청 */}
            <Route path="/drivers/pending" element={<PendingDriverListPage />} />
          </Routes>
        </div>
      </div>
    </Router>
  );
}

export default App;
