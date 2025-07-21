import  { useEffect, useState } from "react";
import { collection, getDocs } from "firebase/firestore";
import { db } from "../firebase";
import './PaymentListPage.css';

function PaymentListPage() {
  const [payments, setPayments] = useState([]);

  useEffect(() => {
    async function fetchPayments() {
      const snap = await getDocs(collection(db, "payments"));
      setPayments(snap.docs.map(doc => ({ id: doc.id, ...doc.data() })));
    }
    fetchPayments();
  }, []);

  return (
    <div className="payment-page-bg">
      <div className="payment-container">
        <h2 className="payment-title">결제 관리</h2>
        <div className="payment-table-wrapper">
          <table className="payment-table">
            <thead>
              <tr>
                <th>ID</th>
                <th>입금자명</th>
                <th>금액</th>
                <th>은행</th>
                <th>상태</th>
                <th>결제일시</th>
                <th>견적ID</th>
              </tr>
            </thead>
            <tbody>
              {payments.map(p => (
                <tr key={p.id}>
                  <td>{p.id.slice(0, 6)}</td>
                  <td>{p.depositorName}</td>
                  <td>{p.amount ? p.amount.toLocaleString() + '원' : '-'}</td>
                  <td>{p.selectedBank || '-'}</td>
                  <td>{p.status || '-'}</td>
                  <td>
                    {p.timestamp?.toDate
                      ? p.timestamp.toDate().toLocaleString()
                      : (p.timestamp || '-')}
                  </td>
                  <td>{p.orderId ? p.orderId.slice(0, 6) : '-'}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}

export default PaymentListPage;
