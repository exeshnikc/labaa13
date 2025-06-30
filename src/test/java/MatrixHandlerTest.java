import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;





/**
 * Набор модульных тестов для проверки функциональности класса MatrixHandler.
 * Покрывает базовые и граничные случаи для методов подсчета и обмена строк.
 */




public class MatrixHandlerTest {

    private int[][] data;
    private MatrixHandler handler;

    /**
     * Инициализация тестовой матрицы перед каждым тестом.
     * Это обеспечивает независимость тестов и чистую среду выполнения.
     */
    @BeforeEach
    public void setUp() {
        data = new int[][]{
                {1, 2, 3},
                {0, 1, 2},
                {4, 5, 6}
        };
        handler = new MatrixHandler(data);
    }

    /**
     * Тестирование корректной работы метода countElementsGreaterThanSumIndices()
     * для обычной (непустой и прямоугольной) матрицы.
     * Ожидается, что метод вернёт количество элементов, которые больше суммы их индексов.
     */
    @Test
    public void testCountElementsNormal() {
        int result = handler.countElementsGreaterThanSumIndices();
        assertEquals(6, result);
    }

    /**
     * Проверка обработки некорректного ввода — пустой матрицы.
     * Метод-конструктор должен выбросить IllegalArgumentException.
     */
    @Test
    public void testEmptyMatrixThrowsException() {
        int[][] empty = new int[0][0];
        assertThrows(IllegalArgumentException.class, () -> {
            new MatrixHandler(empty);
        });
    }

    /**
     * Проверка корректной обработки матрицы размером 1x1.
     * Элемент должен сравниваться с суммой индексов (0+0), и считаться подходящим.
     */
    @Test
    public void testSingleElementMatrix() {
        int[][] single = {{10}};
        MatrixHandler singleHandler = new MatrixHandler(single);
        int count = singleHandler.countElementsGreaterThanSumIndices();
        assertEquals(1, count);
    }

    /**
     * Проверка корректной работы метода swapRows() при обмене строк с допустимыми индексами.
     * В частности, проверяется, что данные в строках поменялись местами.
     */
    @Test
    public void testSwapRowsValid() {
        handler.swapRows(0, 2);
        int[][] result = handler.getMatrix();
        assertEquals(4, result[0][0]);
        assertEquals(1, result[2][0]);
    }

    /**
     * Проверка устойчивости метода swapRows() к неверным индексам.
     * При попытке обмена с несуществующей строкой должно выбрасываться исключение IndexOutOfBoundsException.
     */
    @Test
    public void testSwapRowsInvalidIndex() {
        assertThrows(IndexOutOfBoundsException.class, () -> {
            handler.swapRows(0, 5);
        });
    }

    /**
     * Тестирование поведения при работе с "рваной" матрицей (строки разной длины).
     * Подтверждается, что метод подсчёта не падает с ошибкой.
     * Также проверяется, что обмен строк выполняется корректно даже в такой структуре.
     */
    @Test
    public void testJaggedMatrix() {
        int[][] jagged = {
                {1, 2},
                {3, 4, 5},
                {6}
        };
        MatrixHandler jaggedHandler = new MatrixHandler(jagged);
        int result = jaggedHandler.countElementsGreaterThanSumIndices();
        assertTrue(result >= 0); // Гарантия, что метод не завершился с ошибкой

        MatrixHandler matrix = new MatrixHandler(jagged);
        matrix.swapRows(0, 2);
        int[][] result_mat = matrix.getMatrix();
        assertEquals(6, result_mat[0][0]);
        assertEquals(1, result_mat[2][0]);
    }
}
