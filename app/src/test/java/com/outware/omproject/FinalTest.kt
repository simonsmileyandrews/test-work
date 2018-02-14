package com.outware.omproject

import org.junit.Before
import org.junit.Test
import org.mockito.Mockito

/**
 * This class's purpose is to demonstrate unit testing of final methods.
 *
 * @author kamalmohamed
 */
class FinalTest {

    lateinit var final: Final

    @Before
    fun setup() {
        final = Mockito.mock(Final::class.java)
    }

    @Test
    fun sum_zero() {
        // Arrange
        Mockito.`when`(final.sum(0, 0)).thenReturn(3)

        // Act
        val result = final.sum(0, 0)

        // Assert
        assert(result == 3)
    }

}

class Final {

    fun sum(a: Int, b: Int): Int {
        return a + b
    }

}