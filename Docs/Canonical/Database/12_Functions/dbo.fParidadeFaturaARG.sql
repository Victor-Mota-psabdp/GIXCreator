SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE     FUNCTION [dbo].[fParidadeFaturaARG]
(
@JOB		VarChar(16),
@MoedaIN		Char(3)
		

)
RETURNS float
AS  
	BEGIN 
		Declare @paridade float
		SET @Paridade=(select top 1 paridade from Fatura_ARG_det with(nolock) where num_proc= @JOB and cd_tp_moeda = @MoedaIN)
		Return @Paridade

	END

















GO
