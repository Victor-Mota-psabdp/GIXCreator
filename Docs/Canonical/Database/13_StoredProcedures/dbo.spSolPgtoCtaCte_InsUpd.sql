SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spSolPgtoCtaCte_InsUpd]

	@ID				bigint,
	@Cd_Cred_Dev	varchar(10),
	@Vlr_Doc		decimal(18,2),
	@Dt_Vcto		datetime,
	@Cd_Tp_Doc		varchar(3),
	@Solicitante	varchar(50),
	@InfBanco		varchar(max),
	@Doc_register char(1),
	@Mes		int,
	@Ano		int,	
	@Registro	varchar(6),
	@DtEmissao	datetime,	
	@Lancamento varchar(1),	
	@Doc		varchar(1),
	@Companhia	varchar(30),
	@RUT		varchar(14),
	--@DtVenc		datetime,	
	@cd_Moeda	varchar(20),
	@ValorTC	float,	
	@Isento		varchar(1),
	@Habilita_Impostos bit,
	@Ref_Acesso char(1),
	@cd_servico int,
    @Item_lei varchar(10),
	@TipoFat	varchar(1),
	@Tipo		varchar(50),	
	@DocNumber	Varchar(60),
	@ClienteSeguro	Varchar(30),
	@CNPJSeguro		varchar(14),
	
	@New_ID			bigint output

as

	Declare @Cd_Solicitante	varchar(6)

	
	set @Cd_Solicitante = (Select Cd_usuario from Usuario where Nome_Usuario = @Solicitante)

If @ID is NULL or @ID =''
	Begin
	set @New_ID=(Select max(isnull(ID,8000001))+1  from Sol_Pgto_Cta_Cte)
	if @New_ID is NULL
		Set @New_ID = 8000001
		insert into Sol_Pgto_Cta_Cte(
									ID,
									Cd_Cred_Dev,
									Dt_Pgto_Rcto,
									Vlr_Doc,
									Dt_Vcto,
									Cd_Tp_Doc,
									Cd_Solicitante,
									InfBanco,
									Dt_Ins,
									[Status],
									Doc_Register,
									Mes,
									Ano,
									Num_Registro,
									Cd_Tipo_Lanc,
									Dt_IssueDate,
									--Dt_Venc,
									Isento,
									Cd_Tp_Moeda,
									Par_Moeda,
									Cd_Regra,
									Cd_Tp_Fatura,
									Cd_Tp_Doc_RF,
									Doc_Number,
									Cd_Pes_Seguro,
									NUM_CNPJ_Seguro,
									Habilita_Impostos,
									Ref_Acesso,
									--ativo,
									cd_servico,
									Item_lei
									)
		values
									(
									@New_ID,
									@Cd_Cred_Dev,
									getdate(),
									@Vlr_Doc,
									@Dt_Vcto,
									@Cd_Tp_Doc,
									@Cd_Solicitante,
									@InfBanco,
									getdate(),
									1,
									@Doc_register,
									@Mes,
									@Ano,
									@Registro,
									@Lancamento,
									@DtEmissao,
									--@DtVenc,
									@Isento,
									@Cd_Moeda,
									@ValorTC,
									@Tipo,
									@TipoFat,
									@Doc,
									@DocNumber,
									Null, --@Cd_Cliente_Seguro,
									Null, --@CNPJSeguro,
									@Habilita_Impostos,
									@Ref_Acesso,
									--1,
									@cd_servico,
									@Item_lei
									)
	End
else
	Begin
		update 
			Sol_Pgto_Cta_Cte 
			set
				Cd_Cred_Dev = @Cd_Cred_Dev,
				Vlr_Doc = @Vlr_Doc,
				Dt_Vcto = @Dt_Vcto,
				Cd_Tp_Doc = @Cd_Tp_Doc,
				Cd_Solicitante = @Cd_Solicitante,
				InfBanco = @InfBanco,
				Dt_Ins = GETDATE(),
				Doc_Register = @Doc_register,
				Mes = @Mes,
				Ano = @Ano,
				Num_Registro = @Registro,
				--Cd_Pes_Seguro=@Cd_Cliente_Seguro,
				--Cd_Pes=@Cd_Companhia,
				--Num_CNPJ=@RUT,
				Cd_Tipo_Lanc=@Lancamento,
				Dt_IssueDate=@DtEmissao,
				--Dt_Venc=@DtVenc,
				Isento=@Isento,
				Cd_Tp_Moeda=@Cd_Moeda,
				Par_Moeda=@ValorTC,
				Cd_Regra=@Tipo,
				Cd_Tp_Fatura=@TipoFat,
				Cd_Tp_Doc_RF=@Doc,
				Doc_Number=@DocNumber,
				NUM_CNPJ_Seguro=@CNPJSeguro,
				Habilita_Impostos = @Habilita_Impostos,
				Ref_Acesso = @Ref_Acesso,
				cd_servico = @cd_servico,
				Item_lei = @Item_lei				
				
			where ID = @ID
		
	End
	
	

GO
