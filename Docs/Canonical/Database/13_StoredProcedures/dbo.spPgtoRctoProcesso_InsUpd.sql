SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE procedure [dbo].[spPgtoRctoProcesso_InsUpd]

	@NumLcto varchar(12),
    @Titular varchar(20),
    @DC char(1),
	@DtPgRc  varchar(10),	
	@Forma   varchar(10),
 	@NumDoc  varchar(10),
	@VlrDoc  decimal(10,2),
    @CdPes varchar(20),
	@DtVcto  varchar(10),
    @chkConcil  char(1),
    @chkDoc     char(1),
	@Nome_centro_custo	varchar(50),
	@Nome_BancoTercero varchar(50),
    @Processo   VarChar(12) OUTPUT 
AS

Begin Transaction
--Liberado dia 15/10/2014 - Siberio
----Adicionado o return 0 pra nao inserir pgto div novos - 07/02/14 - Cadu
--	if @NumLcto is null
--		return 0


Declare @Cd_Bco as varchar(3), @Cd_Agen as varchar(5), @NCta as varchar(20) , @cd_centro_custo as varchar(5), @cd_BancoTercero as varchar(5)
    
Set @Cd_Bco = (Select Cd_Banco
               From dbo.Cta_Cte Where Titular = @Titular)

Set @Cd_Agen = (Select Cd_Agencia
               From dbo.Cta_Cte Where Titular = @Titular)

Set @NCta = (Select Num_Cta_Cte
                From dbo.Cta_Cte Where Titular = @Titular)

Set @cd_centro_custo  = (select cd_centro_custo 
				from centro_custo where nome_centro_custo = @Nome_centro_custo)

Set @cd_BancoTercero  = (select cd_banco 
				from Banco_Terceros where nome_Banco = @Nome_BancoTercero)

Declare @Int as int

	if @NumLcto is null

	BEGIN
		Set @Processo='LA'+CAST(year(getdate()) AS Varchar(4))+right('0'+cast(month(getdate()) as VarChar),2)
		sET @Int=(Select isnull(max(right(Num_Lcto,4)),0) from Pgto_Rcto where left(Num_Lcto,8)=@Processo)			
		SET @int=@int+1
		Set @Processo=@Processo+right('000'+Cast(@int as VarChar),4)

		Insert
		      PGTO_RCTO(
				Num_Lcto,
				Cd_Banco,
				Cd_Agencia,
				Num_Cta_Cte,
			    DC,
				Dt_Pgto_Rcto,
				Forma_Pgto_Rcto,
				Num_Doc,
			    Vlr_Doc,
			    Cd_Pes,
				Dt_Vcto,
				Concil,
                Ck_Doctos,
				cd_centro_custo,
				cd_bancoTerceros
				)
		Values
		      (
			@Processo,
            @Cd_Bco,
            @Cd_Agen,
			@NCta,
			@DC,
			@DtPgRc,
			@Forma,
 			@NumDoc,
			@VlrDoc, 
            @CdPes,
			@DtVcto,
            @chkConcil,
            @chkDoc,
			@cd_centro_custo,
			@cd_BancoTercero 
		     ) 
Select @Processo=@Processo
	END
	ELSE
		BEGIN
			UPDATE
				PGTO_RCTO
			Set
				Cd_Banco = @Cd_Bco,
				Cd_Agencia = @Cd_Agen,
				Num_Cta_Cte = @NCta,
				DC = @DC,
				Dt_Pgto_Rcto = @DtPgRc,
				Forma_Pgto_Rcto = @Forma,
				Num_Doc = @NumDoc,
				Vlr_Doc = @VlrDoc,
				Cd_Pes = @CdPes,
				Dt_Vcto = @DtVcto,
				Concil = @chkConcil,
				Ck_Doctos = @chkDoc,
				cd_centro_custo = @cd_centro_custo,
				cd_bancoTerceros = @cd_BancoTercero				
			Where
				Num_Lcto = @NumLcto
				Set @Processo = @NumLcto

--Mudar datas de Pagamento dos Items
			--IM
			Update Caixa_hou_imp_mar set dt_pgto_rcto_him=@DtPgRc where Num_Lcto=@NumLcto
			--IM MASTER
			Update Caixa_mas_imp_mar set dt_pgto_rcto_mim=@DtPgRc where Num_Lcto=@NumLcto
			--EM
			Update Caixa_hou_exp_mar set dt_pgto_rcto_hem=@DtPgRc where Num_Lcto=@NumLcto
			--EM Master			
			Update Caixa_mas_exp_mar set dt_pgto_rcto_mem=@DtPgRc where Num_Lcto=@NumLcto
			--IA 
			Update Caixa_hou_imp_aer set dt_pgto_rcto_hia=@DtPgRc where Num_Lcto=@NumLcto
			--IA Master
			Update Caixa_mas_imp_aer set dt_pgto_rcto_mia=@DtPgRc where Num_Lcto=@NumLcto
			--IO 
			Update Caixa_hou_imp_out set dt_pgto_rcto_hio=@DtPgRc where Num_Lcto=@NumLcto
			--EO
			Update Caixa_hou_exp_out set dt_pgto_rcto_heo=@DtPgRc where Num_Lcto=@NumLcto

		END
		
		
		
Select @Processo 'Processo'
Commit Transaction











GO
