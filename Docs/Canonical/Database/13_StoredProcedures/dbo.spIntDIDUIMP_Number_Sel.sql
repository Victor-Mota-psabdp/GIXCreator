SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[spIntDIDUIMP_Number_Sel]
(
    @Num_Proc VARCHAR(16)
)
AS
BEGIN
    SET NOCOUNT ON;

    IF LEFT(@Num_Proc, 2) = 'IM'
    BEGIN
        SELECT 
            COALESCE(
                (
                    SELECT TOP 1 numero_po_him
                    FROM po_him WITH (NOLOCK)
                    WHERE num_proc_him = @Num_Proc
                      AND id_dc = 237
                ),
                (
                    SELECT TOP 1 numero_po_him
                    FROM po_him WITH (NOLOCK)
                    WHERE num_proc_him = @Num_Proc
                      AND id_dc = 5
                )
            ) AS Numero;
    END
    ELSE IF LEFT(@Num_Proc, 2) = 'IA'
    BEGIN
        SELECT 
            COALESCE(
                (
                    SELECT TOP 1 numero_po_hia
                    FROM po_hia WITH (NOLOCK)
                    WHERE num_proc_hia = @Num_Proc
                      AND id_dc = 237
                ),
                (
                    SELECT TOP 1 numero_po_hia
                    FROM po_hia WITH (NOLOCK)
                    WHERE num_proc_hia = @Num_Proc
                      AND id_dc = 5
                )
            ) AS Numero;
    END
    ELSE IF LEFT(@Num_Proc, 2) = 'IO'
    BEGIN
        SELECT 
            COALESCE(
                (
                    SELECT TOP 1 numero_po_hio
                    FROM po_hio WITH (NOLOCK)
                    WHERE num_proc_hio = @Num_Proc
                      AND id_dc = 237
                ),
                (
                    SELECT TOP 1 numero_po_hio
                    FROM po_hio WITH (NOLOCK)
                    WHERE num_proc_hio = @Num_Proc
                      AND id_dc = 5
                )
            ) AS Numero;
    END
    ELSE
    BEGIN
        SELECT NULL AS Numero;
    END
END

GO
