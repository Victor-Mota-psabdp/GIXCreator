SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




create function [dbo].[fBuscaPorcentagem_DI] --('IMFMT20090600401','00020','0046000919')
(
	@DI Char(16),
	@ADICAO	Varchar(10),
	@ITEM varchar(3)
)

returns
	Float
as
	Begin
		Declare @Total Decimal(10,2)
		deCLARE @TotalITem Decimal(10,2)
		Set @Total = (select SUM(QT_MERC_UN_COMERC*VL_MERC_MOEDA_NEG) from Mercadoria_temp where nr_Declaracao_imp=@DI and nr_adicao=@ADICAO)

		Set @TotalITem = (select SUM(QT_MERC_UN_COMERC*VL_MERC_MOEDA_NEG) from Mercadoria_temp where nr_Declaracao_imp=@DI and nr_adicao=@ADICAO and NR_SEQ_PRODUTO=@ITEM)
	
		if @TotalITem = 0
			Begin
				return 0
			End
		if @TotalITem is null 
			Begin
				return 0
			End
		

		
		Return (@TotalITem/@Total)
		








		END























GO
