import { useState, useEffect } from "react";
import axios from "axios";

const JournalSummary = ({ month }) => {
  const [entries, setEntries] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    axios
      .get(month)
      .then((response) => {
        setEntries(response.data.journal_summary);
        setLoading(false);
      })
      .catch((error) => {
        console.error("Error fetching journal summary:", error);
        setError("Failed to load journal summary");
        setLoading(false);
      });
  }, [month]);

  if (loading) return <p>Loading journal entries...</p>;
  if (error) return <p className="error">{error}</p>;
  if (entries.length === 0) return <p>No data available for this month.</p>;

  // 🔹 Group by account_type to show related debits & credits together
  const groupedEntries = entries.reduce((acc, entry) => {
    if (!acc[entry.account_type]) {
      acc[entry.account_type] = { debit: 0, credit: 0, description: "" };
    }
    if (entry.entry_type === "debit") {
      acc[entry.account_type].debit += parseFloat(entry.total);
    } else {
      acc[entry.account_type].credit += parseFloat(entry.total);
    }
    acc[entry.account_type].description = getDescription(entry.account_type);
    return acc;
  }, {});

  // 🔹 Convert grouped entries into an array for table display
  const tableData = Object.keys(groupedEntries).map((account) => ({
    account,
    debit: groupedEntries[account].debit.toFixed(2),
    credit: groupedEntries[account].credit.toFixed(2),
    description: groupedEntries[account].description,
  }));

  // 🔹 Calculate totals for Debit & Credit columns
  const totalDebit = tableData.reduce((sum, entry) => sum + parseFloat(entry.debit), 0).toFixed(2);
  const totalCredit = tableData.reduce((sum, entry) => sum + parseFloat(entry.credit), 0).toFixed(2);

  // 🔹 Function to provide descriptions for each account type
  function getDescription(account) {
    const descriptions = {
      "accounts_receivable": "Cash expected for orders",
      "revenue": "Revenue for orders",
      "shipping_revenue": "Revenue for shipping",
      "sales_tax_payable": "Cash to be paid for sales tax",
      "cash": "Cash received",
    };
    return descriptions[account] || "";
  }

  return (
    <div className="journal-summary">
      <h2>Journal Summary for {month.split("/").pop()}</h2>
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
          {tableData.map((entry) => (
            <tr key={entry.account}>
              <td>{entry.account.replace("_", " ").toUpperCase()}</td>
              <td>{entry.debit > 0 ? entry.debit : ""}</td>
              <td>{entry.credit > 0 ? entry.credit : ""}</td>
              <td>{entry.description}</td>
            </tr>
          ))}
        </tbody>
        <tfoot>
          <tr>
            <td><strong>Totals</strong></td>
            <td><strong>{totalDebit}</strong></td>
            <td><strong>{totalCredit}</strong></td>
            <td></td>
          </tr>
        </tfoot>
      </table>
    </div>
  );
};

export default JournalSummary;
