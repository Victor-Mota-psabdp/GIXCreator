SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_ADMAdiantamentos_InsUpd]
			@Num_Proc		Varchar(16),
			@Nome_Taxa		Varchar(50),
			@Cd_tp_Tx		Varchar(3),
			@Valor			Decimal(10,2),
			@Dt_Adto		Datetime,
			@Fatura			Varchar(17),
			@Dt_Devol		Datetime,
			@Encerrado		bit,
			@Obs_Adto		Varchar(500),
			@Saldo			Decimal(10,2),
			@Valor_Em_Aberto	Decimal(10,2)

AS

if not exists(select * from ADM_Adiantamentos where num_proc=@Num_proc and cd_tp_Tx=@Cd_Tp_Tx)
	Begin
		Insert
			ADM_Adiantamentos
					(
						Num_Proc,Nome_Taxa,Cd_tp_Tx,Valor,Dt_Adto,Fatura,
						Dt_Devol,Encerrado,Obs_Adto,saldo,valor_em_aberto
					)
			Values
					(
						@Num_Proc,@Nome_Taxa,@Cd_tp_Tx,@Valor,@Dt_Adto,@Fatura,
						@Dt_Devol,@Encerrado,@Obs_Adto,@saldo,@Valor_Em_Aberto 
					)
	End
Else
	Begin
			Update
					ADM_Adiantamentos
						Set
							Saldo = @Saldo,
							Nome_Taxa=@Nome_Taxa,
							Valor_Em_Aberto=@Valor_Em_Aberto ,
							Valor=@Valor,
							Dt_Adto=@Dt_Adto,
							Fatura=@Fatura,
							Dt_Devol=@Dt_Devol,
							Encerrado=@Encerrado,
							Obs_Adto=@Obs_Adto
			Where
						Num_Proc=@num_proc and
						Cd_tp_Tx=@Cd_tp_Tx
							
	End
	
GO
