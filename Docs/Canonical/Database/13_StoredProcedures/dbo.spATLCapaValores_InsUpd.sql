SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--select * from atl_capa_valores
--alter table [dbo].[atl_capa_valores] add [Cd_Tp_Moeda_Frete] [varchar](3) NULL
--alter table [dbo].[atl_capa_valores] add [Cd_Tp_Moeda_CFR] [varchar](3) NULL
--sp_help tipo_moeda
CREATE Procedure [dbo].[spATLCapaValores_InsUpd]
		@Num_Proc				Varchar(16),
		@ValorFob				float,
		@ValorCIF				float,
		@ValorFrete				float,
		@ValorAcrescimoReais	float,
		@ValorSeguroreais		float,
		@valorFOBReais			float,
		@ValorFreteReais		float,
		@Cd_Tp_Moeda_Frete		varchar(3),
		@Cd_Tp_Moeda_CFR		varchar(3),
		@ValorCIFReais		float

as
Begin

if not exists(select * from atl_capa_valores where num_proc=@num_proc)

	Begin
		insert 
			ATL_Capa_Valores(Num_Proc,Fob_USD,CIF_USD,Frete_USD,FOB_REAIS,ACRESCIMOS_REAIS,SEGURO_REAIS,FRETE_REAIS,
			Cd_Tp_Moeda_Frete,Cd_Tp_Moeda_CFR,CIF_Reais)
	
		Values
			(@Num_Proc,@ValorFob,@ValorCIF,@ValorFRete,@ValorFobReais,@ValorAcrescimoReais,@ValorSeguroReais,@ValorFreteReais,
			@Cd_Tp_Moeda_Frete,@Cd_Tp_Moeda_CFR,@ValorCIFReais)
	
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

End



--ALTER Procedure [dbo].[spATLCapaValores_InsUpd]
--		@Num_Proc	Varchar(16),
--		@ValorFob	float,
--		@ValorCIF				float,
--		@ValorFrete				float,
--		@ValorAcrescimoReais float,
--		@ValorSeguroreais	float,
--		@valorFOBReais		float,
--		@ValorFreteReais float

--as
--Begin

--if not exists(select * from atl_capa_valores where num_proc=@num_proc)

--	Begin
--		insert 
--			ATL_Capa_Valores(Num_Proc,Fob_USD,CIF_USD,Frete_USD,FOB_REAIS,ACRESCIMOS_REAIS,SEGURO_REAIS,FRETE_REAIS)
	
--		Values
--			(@Num_Proc,@ValorFob,@ValorCIF,@ValorFRete,@ValorFobReais,@ValorAcrescimoReais,@ValorSeguroReais,@ValorFreteReais)
	
--	End

--Else
--	Begin
--		Update
--			atl_capa_valores
--		SEt
--			FRete_USD=@ValorFrete,
--			FOB_USD=@ValorFob,
--			CIF_USD=@ValorCIF,
--			FOB_REAIS=@ValorFOBReais,
--			ACrescimos_Reais=@ValorAcrescimoReais,
--			Seguro_Reais = @ValorSeguroReais,
--			Frete_Reais=@ValorFreteReais
--		Where
--			Num_Proc=@num_proc
--	End

--End


GO
