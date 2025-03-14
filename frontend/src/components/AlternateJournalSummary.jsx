import { useEffect, useState } from "react";
import axios from "axios";

const AlternateJournalSummary = ({month}) => {
  const [journalEntries, setJournalEntries] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    axios
      .get(month)
      .then((response) => {
        setJournalEntries(response.data.journal_summary);
        setLoading(false);
      })
      .catch((error) => {
        console.error("Error fetching journal summary:", error);
        setError("Failed to load journal summary");
        setLoading(false);
      });
  }, [month]);

  const getEntryTotal = (entries, accountType, entryType) => {
    const entry = entries.find(
      (e) => e.account_type === accountType && e.entry_type === entryType
    );
    return entry ? entry.total : "0.00";
  };

  if (loading) return <p>Loading journal summary...</p>;
  if (error) return <p className="error">{error}</p>;

  return (
    <div className="table-container">
      <table>
        <thead>
          <tr>
            <th>Account</th>
            <th>Debit ($)</th>
            <th>Credit ($)</th>
            <th>Description</th>
          </tr>
        </thead>
        <tbody>
          <tr><td>Accounts Receivable</td><td>{getEntryTotal(journalEntries, "revenue", "credit")}</td><td></td><td>Cash expected for orders</td></tr>
          <tr><td>Revenue</td><td></td><td>{getEntryTotal(journalEntries, "revenue", "credit")}</td><td>Revenue for orders</td></tr>
          <tr><td>Accounts Receivable</td><td>{getEntryTotal(journalEntries, "shipping_revenue", "credit")}</td><td></td><td>Cash expected for shipping on orders</td></tr>
          <tr><td>Shipping Revenue</td><td></td><td>{getEntryTotal(journalEntries, "shipping_revenue", "credit")}</td><td>Revenue for shipping</td></tr>
          <tr><td>Accounts Receivable</td><td>{getEntryTotal(journalEntries, "sales_tax_payable", "credit")}</td><td></td><td>Cash expected for taxes</td></tr>
          <tr><td>Sales Tax Payable</td><td></td><td>{getEntryTotal(journalEntries, "sales_tax_payable", "credit")}</td><td>Cash to be paid for sales tax</td></tr>
          <tr><td>Cash</td><td>{getEntryTotal(journalEntries, "cash", "debit")}</td><td></td><td>Cash received</td></tr>
          <tr><td>Accounts Receivable</td><td></td><td>{getEntryTotal(journalEntries, "accounts_receivable", "credit")}</td><td>Removal of expectation of cash</td></tr>
          <tr>
            <td></td>
            <td>{Number(getEntryTotal(journalEntries, "cash", "debit")) + Number(getEntryTotal(journalEntries, "cash", "debit"))}</td>
            <td>{Number(getEntryTotal(journalEntries, "accounts_receivable", "credit")) + Number(getEntryTotal(journalEntries, "accounts_receivable", "credit"))}</td>
            <td></td>
          </tr>
        </tbody>
      </table>
    </div>
  );
};

export default AlternateJournalSummary;
