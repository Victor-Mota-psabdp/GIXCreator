SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure [dbo].[spATL_NetRevenueBDP3Party_Sel] --spATL_NetRevenueBDP3Party_Sel '','12-01-2012','12-31-2012'
	(
	@Grupo			Varchar(50),

	@DataInicial	Datetime,
	@DataFinal		DAtetime
	)
AS


Declare @Table Table
	(
		Grupo Varchar(50),
		Num_Proc	Varchar(50) ,
		NF			Decimal(10,2) Default 0,
		GrossBilling	Decimal(10,2)Default 0 ,
		Costs			Decimal(10,2)Default 0,
		Mes				int,
		ano				int,
		Tipo			Varchar(30)
		)

Insert @Table(Grupo,Num_Proc,NF,mes,ano,tipo)
Select 
	Isnull(PP.Apelido,CL.apelido),Num_Proc_Hia,sum(dbo.valor(vlr_pgto_nf_hia,dc_hia)),month(emissao) Mes,year(emissao) Mes ,
	(
		Case Upper(AGT.Cd_tp_Ativ)
			when 'AGT' then 'BDP'
			else '3. Party'
		End
	)
			

From vwcta_cte cta
Join Base_Nota_Fiscal NF on num_nf_hia=notA_fiscal and ref_acesso_nf_hia=ref_Acesso
Join vwcliente C on C.num_proc=cta.num_proc_hia
Join PessoA_LLP PLL on pll.cd_pes=cd_cliente
Left Join Pessoa PP on pP.cd_pes=PLL.cd_pes_grupo and cd_pes_Grupo <> 'GRATL'
Join Pessoa CL on CL.cd_pes=cd_cliente
Join Pessoa AGT on AGT.cd_pes=cd_cred_dev_hia
where
	emissao between @DataInicial and @DataFinal
	and (pp.apelido = @Grupo or @Grupo='')
	
group by Isnull(PP.Apelido,CL.apelido),Num_Proc_Hia,
month(emissao) ,year(emissao) ,AGT.cd_tp_Ativ

insert @Table
Select Isnull(PP.Apelido,CL.apelido),cxa.Num_Proc_Hia,0,sum(dbo.valor(Vlr_pgto_Rcto_hia,cxa.dc_hia)),0,month(convert(Datetime,dt_pgto_rcto_hia,105) ),year(convert(Datetime,dt_pgto_rcto_hia,105) ) ,	(
		Case Upper(agt.Cd_tp_Ativ)
			when 'AGT' then 'BDP'
			else '3. Party'
		End
	)
 
from vwcxas CXA
Join vwcta_cte cta on cta.num_proc_hia=cxa.num_proc_hia and cta.dc_hia=cxa.dc_hia and cta.cd_tp_tx=cxa.cd_tp_Tx
Left Join Base_Nota_Fiscal NF on num_nf_hia=notA_fiscal and ref_acesso_nf_hia=ref_Acesso
Join vwcliente C on C.num_proc=cta.num_proc_hia
Join PessoA_LLP PLL on pll.cd_pes=cd_cliente
Left Join Pessoa PP on pP.cd_pes=PLL.cd_pes_grupo and cd_pes_Grupo <> 'GRATL'
Join Pessoa CL on CL.cd_pes=cd_cliente
Join Pessoa AGT on AGT.cd_pes=cd_cred_dev_hia

where
	convert(Datetime,dt_pgto_rcto_hia,105) between @DataInicial and @DataFinal
	and emissao is null  and cxa.dc_hia='C'
	and (pp.apelido = @Grupo or @Grupo='')

group by Isnull(PP.Apelido,CL.apelido),cxa.Num_Proc_Hia,year(convert(Datetime,dt_pgto_rcto_hia,105) ),month(convert(Datetime,dt_pgto_rcto_hia,105) ),AGT.cd_tp_Ativ

insert @Table

select Isnull(PP.Apelido,CL.apelido),RFI.num_proc,0,0,sum(dbo.valor(Isnull(RFi.valor_total_Moeda_Local,RFI.Valor_Total),RFI.DC)),RF.mes,RF.ano,'3. Party' from registro_financeiro rf
Join Registro_financeiro_item RFI on rfi.num_registro=rf.num_registro and RFI.ano=rf.ano and rfi.mes=rf.mes and ativo='1'
Join vwcliente C on C.num_proc=RFI.num_proc
Join PessoA_LLP PLL on pll.cd_pes=cd_cliente
Left Join Pessoa PP on pP.cd_pes=PLL.cd_pes_grupo and cd_pes_Grupo <> 'GRATL'
Join Pessoa CL on CL.cd_pes=cd_cliente
where
	RF.ano=year(@DataInicial) and rf.mes=month(@datainicial) and 
	(pp.apelido = @Grupo or @Grupo='')

group by Isnull(PP.Apelido,CL.apelido),RFI.num_proc,rf.ano,rf.mes


--select Grupo,Num_Proc,NF,GrossBilling,Costs,NF+Costs [Net Revenue],tipo from @Table

Select Tipo,sum(GrossBilling+NF) from @Table group by Tipo
GO
