SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO















create function [dbo].[spRateioFrete_Mas]
			(@Num_Proc varchar(16)
			)

returns
	Float
as
	Begin
		Declare @Qtd FLOAT
		Declare @FreteHouse Float
		Declare @Num_Master varchar(14)
		
		Set @Num_master =(select [master] from vwcliente where num_proc=@Num_Proc)
		if @Num_Master is null
			Begin
			
				return 1
			End
		set @qtd= (select sum(vlr_frete_efet_him) from house_imp_mar where num_proc_mim=@num_Master)
		set @FreteHouse= (select sum(vlr_frete_efet_him) from house_imp_mar where num_proc_him=@num_proc)
		
		if @QTD is null or @QTD=0
			begin
				REturn 1
			End
		Else
			begin
			
				return((@FreteHouse/@qtd))
			
			End
		return 1
		End
		
		
		
GO
