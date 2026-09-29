SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE		FUNCTION fNATOP
(
@Processo	Varchar(16)
)
RETURNS Varchar(400) 
AS  
	BEGIN 
		Declare @nNCM	VarChar(400)
		Declare @NCM	varchar(400) 

		Declare Cur_NCM cursor for 
			select 
				PD.NATOP		
			from
				House_exp_aer HOU
	Left Join Pedido_Ship	PS	on HOU.Num_Proc_HEA	=PS.Num_Proc
	Left Join Pedido	P	on PS.Cd_Pedido		=P.Cd_Pedido 
	Left Join Pedido_Det	PD	on PS.Cd_Pedido 	=PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
			Where
				num_proc_hea=@Processo
		group by PD.NATOP
	Union all

			select 
				PD.NATOP		
			from
				House_exp_mar HOU
	Left Join Pedido_Ship	PS	on HOU.Num_Proc_HEm	=PS.Num_Proc
	Left Join Pedido	P	on PS.Cd_Pedido		=P.Cd_Pedido 
	Left Join Pedido_Det	PD	on PS.Cd_Pedido 	=PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
			Where
				num_proc_hem=@Processo
			group by PD.NATOP
	Union all

			select 
				PD.NATOP		
			from
				House_exp_out HOU
	Left Join Pedido_Ship	PS	on HOU.Num_Proc_HEo	=PS.Num_Proc
	Left Join Pedido	P	on PS.Cd_Pedido		=P.Cd_Pedido 
	Left Join Pedido_Det	PD	on PS.Cd_Pedido 	=PD.Cd_Pedido and PS.Cd_Produto = PD.Cd_Produto
			Where
				num_proc_heo=@Processo
			group by PD.NATOP

		open Cur_NCM
			Fetch Next From Cur_NCM Into @NCM
			While @@FETCH_STATUS = 0
			Begin
				if @nNCM='' or @nNCM is Null
					Begin
						Set @nNCM=@NCM
					end
				else
					begin
						set @nNCM=@nNCM + ' - '  + @NCM
					end
				
				Fetch Next From Cur_NCM Into @NCM
			end
		close Cur_NCM
		deallocate Cur_NCM 

	return @nNCM
		
	END




GO
