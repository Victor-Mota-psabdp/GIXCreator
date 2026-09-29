SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from atl_capa_valores
--alter table [dbo].[atl_capa_valores] add [Cd_Tp_Moeda_Frete] [varchar](3) NULL
--alter table [dbo].[atl_capa_valores] add [Cd_Tp_Moeda_CFR] [varchar](3) NULL
--sp_help tipo_moeda
CREATE Procedure [dbo].[spATL_Capa_Valores_InsUpd]
		@Num_Proc				Varchar(16),
		@ValorFob				decimal(18,2),
		@ValorCIF				decimal(18,2),
		@ValorFrete				decimal(18,2),
		@ValorAcrescimoReais	decimal(18,2),
		@ValorSeguroreais		decimal(18,2),
		@valorFOBReais			decimal(18,2),
		@ValorFreteReais		decimal(18,2),
		@Cd_Tp_Moeda_Frete		varchar(3),
		@Cd_Tp_Moeda_CFR		varchar(3),
		@ValorCIFReais		    decimal(18,2)

as
Begin Transaction

if not exists(select * from atl_capa_valores where num_proc=@num_proc)

	Begin
		insert 
			ATL_Capa_Valores
				(Num_Proc,
				Fob_USD,
				CIF_USD,
				Frete_USD,
				FOB_REAIS,
				ACRESCIMOS_REAIS,
				SEGURO_REAIS,
				FRETE_REAIS,
				Cd_Tp_Moeda_Frete,
				Cd_Tp_Moeda_CFR,
				CIF_Reais)
		Values
				(@Num_Proc,
				@ValorFob,
				@ValorCIF,
				@ValorFRete,
				@ValorFobReais,
				@ValorAcrescimoReais,
				@ValorSeguroReais,
				@ValorFreteReais,
				@Cd_Tp_Moeda_Frete,
				@Cd_Tp_Moeda_CFR,
				@ValorCIFReais)
	End
Else
	Begin
		Update
			atl_capa_valores
		SEt
			FRete_USD=@ValorFrete,
			FOB_USD=@ValorFob,
			CIF_USD=@ValorCIF,
			FOB_REAIS=@ValorFOBReais,
			ACrescimos_Reais=@ValorAcrescimoReais,
			Seguro_Reais = @ValorSeguroReais,
			Frete_Reais=@ValorFreteReais,
			Cd_Tp_Moeda_Frete =@Cd_Tp_Moeda_Frete ,
			Cd_Tp_Moeda_CFR = @Cd_Tp_Moeda_CFR,
			CIF_Reais=@ValorCIFReais
		Where
			Num_Proc=@num_proc
	End
		
	if @@error <> 0 
		Begin
			Rollback transaction
			return -1
		end
commit transaction

GO
