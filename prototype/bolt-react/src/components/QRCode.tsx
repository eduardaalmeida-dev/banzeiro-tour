interface QRCodeProps {
  value: string;
  size?: number;
}

export function QRCode({ value, size = 180 }: QRCodeProps) {
  const cells = 21;
  const cellSize = size / cells;

  // Simple deterministic hash-based pattern
  const matrix: boolean[][] = [];
  let hash = 0;
  for (let i = 0; i < value.length; i++) {
    hash = ((hash << 5) - hash + value.charCodeAt(i)) | 0;
  }
  let seed = Math.abs(hash) || 1;

  const rand = () => {
    seed = (seed * 9301 + 49297) % 233280;
    return seed / 233280;
  };

  for (let r = 0; r < cells; r++) {
    const row: boolean[] = [];
    for (let c = 0; c < cells; c++) {
      row.push(rand() > 0.5);
    }
    matrix.push(row);
  }

  // Finder patterns (corners)
  const setFinder = (sr: number, sc: number) => {
    for (let r = 0; r < 7; r++) {
      for (let c = 0; c < 7; c++) {
        const isBorder = r === 0 || r === 6 || c === 0 || c === 6;
        const isInner = r >= 2 && r <= 4 && c >= 2 && c <= 4;
        matrix[sr + r][sc + c] = isBorder || isInner;
      }
    }
    // Clear separator
    for (let i = 0; i < 8; i++) {
      if (sr + 7 < cells) matrix[sr + 7][sc + i] = false;
      if (sc + 7 < cells) matrix[sr + i] && (matrix[sr + i][sc + 7] = false);
    }
  };

  setFinder(0, 0);
  setFinder(0, cells - 7);
  setFinder(cells - 7, 0);

  return (
    <svg width={size} height={size} viewBox={`0 0 ${size} ${size}`} className="rounded-lg">
      <rect width={size} height={size} fill="#FFFFFF" />
      {matrix.map((row, r) =>
        row.map((on, c) =>
          on ? (
            <rect
              key={`${r}-${c}`}
              x={c * cellSize}
              y={r * cellSize}
              width={cellSize}
              height={cellSize}
              fill="#0E3D1D"
            />
          ) : null
        )
      )}
    </svg>
  );
}
