SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--sp_help Sol_Pgto_Cta_Cte
CREATE PROCEDURE [dbo].[spATL_Sol_Pgto_Cta_Cte_InsUpd]
(
	@ID					bigint,
	@Cd_Cred_Dev		varchar(10),		
	@Dt_Pgto_Rcto		datetime,
	@Vlr_Doc			decimal(18,2),
	@Dt_Vcto			datetime,
	@Cd_Tp_Doc			varchar(3),
	@Cd_Solicitante		varchar(6),
	@Cd_Gerente			varchar(6),
	@Cd_Diretor			varchar(6),
	@Dt_Ins				datetime,
	@Status				bit,
	@Status_Aprovacao	char(1),
	@Dt_Aprovacao		datetime,

	@Doc_register		char(1),
	@Mes				int,
	@Ano				int,	
	@Num_Registro		varchar(6),
	@Dt_IssueDate		datetime,	
	@Cd_Tipo_Lanc		varchar(1),
	@Isento				varchar(1),
	@Cd_Tp_Moeda		varchar(20),
	@Par_Moeda			float,
	@Cd_Regra			varchar(50),
	@Cd_Tp_Fatura		varchar(1),
	@Cd_Tp_Doc_RF		varchar(1),
	@Doc_Number			Varchar(60),
	@Total				decimal(10,2),
	@IVA_Retencoes		decimal(10,2),
	@Total_Doc			decimal(10,2),
	@Cd_Pes_Seguro		Varchar(50),
	@NUM_CNPJ_Seguro	varchar(14),
	@Valor_Total_Moeda_Local float,	
	@Habilita_Impostos	bit,
	@Ref_Acesso			char(1),
	@cd_servico			int,
    @Item_lei			varchar(10),
	@InfBanco			varchar(max),
	@New_ID				bigint output
)
as


If @ID is NULL or @ID =''
	Begin
		set @New_ID=(Select max(isnull(ID,8000001))+1  from Sol_Pgto_Cta_Cte)
		if @New_ID is NULL
			Set @New_ID = 8000001

			insert into Sol_Pgto_Cta_Cte
			(
				ID,Cd_Cred_Dev,Dt_Pgto_Rcto,Vlr_Doc,Dt_Vcto,Cd_Tp_Doc,Cd_Solicitante,Cd_Gerente,Cd_Diretor,Dt_Ins,Status,--Status_Aprovacao,
				Dt_Aprovacao,
				Doc_Register,Mes,Ano,Num_Registro,Dt_IssueDate,Cd_Tipo_Lanc,Isento,Cd_Tp_Moeda,Par_Moeda,Cd_Regra,Cd_Tp_Fatura,Cd_Tp_Doc_RF,Doc_Number,
				Total,IVA_Retencoes,Total_Doc,Cd_Pes_Seguro,NUM_CNPJ_Seguro,Valor_Total_Moeda_Local,Habilita_Impostos,Ref_Acesso,cd_servico,Item_lei,InfBanco
			)
			values
			(
				@New_ID,@Cd_Cred_Dev,getdate(),@Vlr_Doc,@Dt_Vcto,@Cd_Tp_Doc,@Cd_Solicitante,@Cd_Gerente,@Cd_Diretor,getdate(),1,--@Status_Aprovacao,
				@Dt_Aprovacao,
				@Doc_register,@Mes,@Ano,@Num_Registro,@Dt_IssueDate,@Cd_Tipo_Lanc,@Isento,@Cd_Tp_Moeda,@Par_Moeda,@Cd_Regra,@Cd_Tp_Fatura,@Cd_Tp_Doc_RF,@Doc_Number,
				@Total,@IVA_Retencoes,@Total_Doc,@Cd_Pes_Seguro,@NUM_CNPJ_Seguro,@Valor_Total_Moeda_Local,@Habilita_Impostos,@Ref_Acesso,@cd_servico,@Item_lei,@InfBanco
			)
	End
else
	Begin
		update 
			Sol_Pgto_Cta_Cte 
		set
			Cd_Cred_Dev		=	@Cd_Cred_Dev,
			Dt_Pgto_Rcto	=	@Dt_Pgto_Rcto,
			Vlr_Doc			=	@Vlr_Doc,
			Dt_Vcto			=	@Dt_Vcto,
			Cd_Tp_Doc		=	@Cd_Tp_Doc,
			Cd_Solicitante	=	@Cd_Solicitante,
			Cd_Gerente		=	@Cd_Gerente,
			Cd_Diretor		=	@Cd_Diretor,				
			Dt_Ins			=	@Dt_Ins,
			Status			=	@Status,
			--Status_Aprovacao=	@Status_Aprovacao,
			Dt_Aprovacao	=	@Dt_Aprovacao,
			Doc_Register	=	@Doc_Register,
			Mes				=	@Mes,
			Ano				=	@Ano,
			Num_Registro	=	@Num_Registro,
			Dt_IssueDate	=	@Dt_IssueDate,
			Cd_Tipo_Lanc	=	@Cd_Tipo_Lanc,
			Isento			=	@Isento,
			Cd_Tp_Moeda		=	@Cd_Tp_Moeda,
			Par_Moeda		=	@Par_Moeda,
			Cd_Regra		=	@Cd_Regra,
			Cd_Tp_Fatura	=	@Cd_Tp_Fatura,
			Cd_Tp_Doc_RF	=	@Cd_Tp_Doc_RF,
			Doc_Number		=	@Doc_Number,
			Total			=	@Total,
			IVA_Retencoes	=	@IVA_Retencoes,
			Total_Doc		=	@Total_Doc,
			Cd_Pes_Seguro	=	@Cd_Pes_Seguro,
			NUM_CNPJ_Seguro	=	@NUM_CNPJ_Seguro,
			Valor_Total_Moeda_Local=@Valor_Total_Moeda_Local,	
			Habilita_Impostos = @Habilita_Impostos,
			Ref_Acesso		= @Ref_Acesso,
			cd_servico		= @cd_servico,
			Item_lei		= @Item_lei,
			InfBanco		= @InfBanco			
		where 
			ID = @ID

		set @New_ID =@ID 
		
	End
	
	

GO
