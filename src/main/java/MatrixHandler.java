/**
 * Класс MatrixHandler реализует базовые операции над двумерной матрицей целых чисел.
 * Поддерживает подсчёт элементов с заданным условием, а также безопасную перестановку строк.
 * Может использоваться в учебных, аналитических и демонстрационных целях.
 */
public class MatrixHandler {

    /**
     * Внутреннее представление матрицы.
     * Каждая строка массива может иметь разную длину (рваная матрица).
     */
    private int[][] matrix;

    /**
     * Конструктор для инициализации матрицы.
     *
     * @param matrix двумерный массив целых чисел, представляющий исходную матрицу.
     * @throws IllegalArgumentException если передана null-ссылка, пустая матрица,
     *                                  либо первая строка не определена.
     */
    public MatrixHandler(int[][] matrix) {
        if (matrix == null || matrix.length == 0 || matrix[0] == null) {
            throw new IllegalArgumentException("Матрица не должна быть null или пустой");
        }
        this.matrix = matrix;
    }

    /**
     * Подсчитывает количество элементов, которые строго больше суммы своих индексов (i + j),
     * то есть выполняется условие: matrix[i][j] > (i + j).
     * Применимо для анализа "сильных" значений в матрице по координатному положению.
     *
     * @return количество элементов, удовлетворяющих условию a[i][j] > i + j
     */
    public int countElementsGreaterThanSumIndices() {
        int count = 0;
        for (int i = 0; i < matrix.length; i++) {
            for (int j = 0; j < matrix[i].length; j++) {
                if (matrix[i][j] > (i + j)) {
                    count++;
                }
            }
        }
        return count;
    }

    /**
     * Меняет местами две строки матрицы по заданным индексам.
     * Метод безопасен — он проверяет допустимость индексов перед выполнением обмена.
     *
     * @param k1 индекс первой строки
     * @param k2 индекс второй строки
     * @throws IndexOutOfBoundsException если хотя бы один из индексов выходит за границы массива
     */
    public void swapRows(int k1, int k2) {
        if (k1 < 0 || k1 >= matrix.length || k2 < 0 || k2 >= matrix.length) {
            throw new IndexOutOfBoundsException("Индексы строк вне диапазона");
        }
        int[] temp = matrix[k1];
        matrix[k1] = matrix[k2];
        matrix[k2] = temp;
    }

    /**
     * Предоставляет внешний доступ к текущему состоянию матрицы.
     * Полезно для тестирования, отладки и визуализации после модификаций.
     *
     * @return текущая версия матрицы
     */
    public int[][] getMatrix() {
        return matrix;
    }
}
