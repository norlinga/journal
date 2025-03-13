import { useState } from "react";
import MonthsList from "./components/MonthsList";
import JournalSummary from "./components/JournalSummary";

const App = () => {
  const [selectedMonth, setSelectedMonth] = useState(null);

  return (
    <div>
      <h1>Journal Entries</h1>
      <MonthsList onSelectMonth={setSelectedMonth} />
      {selectedMonth && <JournalSummary month={selectedMonth} />}
    </div>
  );
};

export default App;
