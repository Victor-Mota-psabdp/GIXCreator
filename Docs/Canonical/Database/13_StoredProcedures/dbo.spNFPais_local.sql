SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





CREATE    pROCEDURE [dbo].[spNFPais_local] 
		(
		@DataInicial Varchar(10),
		@DataFinal Varchar(10),
		@Site	Char(1)
	)

AS

IF @SITE='A' and cast(@dataInicial as Datetime) >='12-01-2006' 
BEGIN
	select 

	nota_fiscal, emissao, apelido,valor_total, PAIS

	from 
	base_nota_fiscal as nf

	inner join pessoa as pp on (nf.cd_pes=pp.cd_peS)
	inner join endereco as ender on (ender.cd_pes=pp.cd_pes) and cd_tp_end='COM'
	
	where 
		cd_status <> 2 
		and RPS_DATA between @DataInicial and CAST(@DataFinal AS DATETIME)+'23:59'
		and ref_acesso=@Site

	group by 
		nota_fiscal, emissao, apelido,valor_total, PAIS

	order by 
		nota_fiscal 

END
ELSE
BEGIN
	select 

	nota_fiscal, emissao, apelido,valor_total, PAIS

	from 
	base_nota_fiscal as nf

	inner join pessoa as pp on (nf.cd_pes=pp.cd_peS)
	inner join endereco as ender on (ender.cd_pes=pp.cd_pes) and cd_tp_end='COM'
	
	where 
		cd_status <> 2 
		and emissao between @DataInicial and @DataFinal
		and ref_acesso=@Site

	group by
		nota_fiscal, emissao, apelido,valor_total, PAIS

	order by 
		nota_fiscal 
END







GO
