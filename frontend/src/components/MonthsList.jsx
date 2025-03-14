import { useState, useEffect } from "react";
import axios from "axios";

const MonthsList = ({ onSelectMonth }) => {
  const [months, setMonths] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  const handleClick = (month) => {
    console.log("Clicked month:", month.link);
    onSelectMonth(month.link);
  };

  useEffect(() => {
    axios
      .get("/api/journal/months")
      .then((response) => {
        setMonths(response.data.months);
        setLoading(false);
      })
      .catch((error) => {
        console.error("Error fetching months:", error);
        setError("Failed to load months");
        setLoading(false);
      });
  }, []);

  if (loading) return <p>Loading months...</p>;
  if (error) return <p className="error">{error}</p>;

  return (
    <div className="sidebar">
      <h2>Available Months</h2>
      <ul>
        {months.map((month) => (
          <li key={month.link}>
            <button className="month-button" onClick={() => handleClick(month)}>
              {month.month} ({month.order_count})
            </button>
          </li>
        ))}
      </ul>

      <p>
        <a href="http://localhost:3000/maintenance_tasks" target="_blank" rel="noopener noreferrer">
        MaintenanceTasks
        </a>
      </p>
    </div>
  );
};

export default MonthsList;