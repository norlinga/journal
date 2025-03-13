import { useState, useEffect } from "react";
import axios from "axios";

const JournalSummary = ({ month }) => {
  const [journalEntries, setJournalEntries] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    if (!month) return;

    setLoading(true);
    setError(null);

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

  if (loading) return <p>Loading journal summary...</p>;
  if (error) return <p className="error">{error}</p>;
  if (journalEntries.length === 0) return <p>No journal entries found.</p>;

  return (
    <div>
      <h2>Journal Summary for {month}</h2>
      <table border="1">
        <thead>
          <tr>
            <th>Account Type</th>
            <th>Entry Type</th>
            <th>Total</th>
          </tr>
        </thead>
        <tbody>
          {journalEntries.map((entry, index) => (
            <tr key={index}>
              <td>{entry.account_type.replace("_", " ")}</td>
              <td>{entry.entry_type}</td>
              <td>${entry.total}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default JournalSummary;
