import { useState } from "react";
import MonthsList from "./components/MonthsList";
import JournalSummary from "./components/JournalSummary";
import AlternateJournalSummary from "./components/AlternateJournalSummary";
import "./App.css";

const App = () => {
  const [selectedMonth, setSelectedMonth] = useState(null);

  return (
    <div className="container">
      <MonthsList onSelectMonth={setSelectedMonth} />

      <div className="content">
        <h1>Journal Summary</h1>
        {selectedMonth ? (
          <JournalSummary month={selectedMonth} />
        ) : (
          <p>Select a month to view details.</p>
        )}

        <h2 className="alternate-journal-summary">Alternate Journal Summary</h2>
        {selectedMonth ? (
          <AlternateJournalSummary month={selectedMonth} />
        ) : (
          <p>&nbsp;</p>
        )}
      </div>
    </div>
  );
};

export default App;
