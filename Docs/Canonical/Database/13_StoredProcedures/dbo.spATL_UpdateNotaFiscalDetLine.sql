SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- 02-01-2026 - antonio - gravar a numeração da nota fiscal da tabela  ATL_INT.dbo.JSON_FComex_Nota_Cliente_Line 
-- a de itens para amarrar na ATL_INT.dbo.JSON_FComex_Nota_Cliente_Det_Lin
CREATE PROCEDURE [dbo].[spATL_UpdateNotaFiscalDetLine]
AS

Declare @Id_Processo bigint,
        @Nota_Fiscal varchar(200)

Declare curNFDL cursor For

  select id_processo, Nota_Fiscal from ATL_INT.dbo.JSON_FComex_Nota_Cliente_Line 

OPEN curNFDL 
Fetch Next From curNFDL Into @Id_Processo, @Nota_Fiscal

While @@Fetch_Status = 0 Begin

    print @id_processo
    print @Nota_Fiscal

    update ATL_INT.dbo.JSON_FComex_Nota_Cliente_Det_Line SET Nota_Fiscal=@Nota_Fiscal
    where id_processo=@id_processo


Fetch Next From curNFDL Into @id_processo, @Nota_Fiscal

End -- End of Fetch

Close curNFDL 
Deallocate curNFDL 
GO
