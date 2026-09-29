SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spNFCanceladas_Sel] --'A','2014/10/01','2014/10/10'
	@cd_site varchar(50), 	
	@dt_inicial datetime,
	@dt_final datetime
as

If @Cd_Site <> ''
Begin
	set @Cd_Site = (Select left(@Cd_Site,1))
End

	select 
		Numero [Nota Fiscal],
		ST.Cd_Site +' - '+ST.Nome_Site [Site],
		Pe.nome_raz_soc	[Cliente],
		PE.num_cpf_cnpj [CNPJ],
		NF.Dt_Fatura [Dt. Emissão],
		BN.dt_Cancel [Dt. Cancel],
		Valor_Total [Valor]
	from Fatura_Arg NF with(nolock)
		join pessoa PE with(nolock) on pe.cd_pes = NF.cd_pes
		join site ST with(nolock) on st.cd_site = NF.Codigo
		Join Base_Nota_Fiscal BN with(nolock) on NF.Numero =BN.Nota_Fiscal  and NF.Codigo = BN.Ref_Acesso
	where
		NF.Dt_Fatura between @dt_inicial and @dt_final
		and (ST.cd_site = @cd_site or @Cd_Site = '')
		and NF.status = 2

	order by nota_fiscal

--select * from Base_nota_fiscal	
--select * from Nota_Cliente
--[spBuscaNFcomDN_Sel] '19238','A'
--select * from fatura_Arg_det where Num_Proc = 'IAMRK201201001BR'
--select * from fatura_Arg where ID_Fat = 171

--select * from 
GO
