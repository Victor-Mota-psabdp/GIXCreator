SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE  function [dbo].[fBusca_Rent_DiaModal](
@Modal	varchar(2),
@Data	varchar(10)
)
RETURNS Float

BEGIN
	Declare @Resultado Float

	IF @MODAL <> 'O'
		BEGIN
			SET @Resultado=Isnull((
				select sum(VALOR) from CML.DBO.CLIENTES_TOP  
				where MODAL=@modal and nome_tp_tx   not in ('Serviços de Despacho 1','Emissão de Form A 1','Emissão de Form A 2','Emissão de Form A 3','Emissão de Form A 4','Emissão de Form A 5','Emissão de Form A','Emissão de RE')
				and dt_ins=@data),0)
		END
	ELSE
		BEGIN
			SET @Resultado=Isnull((
				select sum(VALOR) from CML.DBO.CLIENTES_TOP  
				where MODAL=@modal and nome_tp_tx    in ('Serviços de Despacho 1','Emissão de Form A 1','Emissão de Form A 2','Emissão de Form A 3','Emissão de Form A 4','Emissão de Form A 5','Emissão de Form A','Emissão de RE')
				and dt_ins=@data),0)
		END
	RETURN @Resultado
END



GO
