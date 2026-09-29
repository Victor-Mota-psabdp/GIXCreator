SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_Custo_Processo_Sel]
		
		@Num_Proc	Varchar(16),
		@Cd_Tp_Tx   Varchar(3),
		@Tipo	    Varchar(1)
as

if @Tipo ='A' 
	begin 
			Select 
					cp.Num_Proc          [JOB],
					cp.Cd_Tp_Tx          [Charge Code],
					tt.Nome_Tp_Tx        [Charge Name], 
					cp.Valor             [Value],
					cp.Dt_Rateio         [Dt Sharing]
			from    Custo_Processo cp
					Join Tipo_Taxa TT on TT.cd_tp_tx=cp.cd_tp_tx
			Where 
					cp.Num_Proc=@Num_Proc
	end 

if @Tipo ='D' 
	begin 
			Select 
					cp.Num_Proc          [JOB],
					cp.Cd_Tp_Tx          [Charge Code],
					tt.Nome_Tp_Tx        [Charge Name], 
					cp.Valor             [Value],
					cp.Dt_Rateio         [Dt Sharing]
			from    Custo_Processo cp
					Join Tipo_Taxa TT on TT.cd_tp_tx=cp.cd_tp_tx
			Where 
					cp.Num_Proc=@Num_Proc
			And		cp.Cd_Tp_Tx = @Cd_Tp_Tx
	end 

GO
