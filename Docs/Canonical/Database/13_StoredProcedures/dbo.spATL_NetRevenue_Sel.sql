SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--spATL_NetRevenue_Sel '','2018/01/01','2018/12/31'
--9/2/2018 - comentado no 3 select --and cd_pes_Grupo <> 'GRATL' 11798
CREATE  Procedure [dbo].[spATL_NetRevenue_Sel] --spATL_NetRevenue_Sel 'GRUPO CORBION','01-01-2015','12-14-2015'
	(
	@Grupo			Varchar(50),

	@DataInicial	Datetime,
	@DataFinal		DAtetime
	)
AS


Declare @Table Table
	(
		Grupo Varchar(50),
		Cliente Varchar(50),
		Num_Proc	Varchar(50) ,
		NF			Decimal(10,2) Default 0,
		GrossBilling	Decimal(10,2)Default 0 ,
		Costs			Decimal(10,2)Default 0,
		Mes				int,
		ano				int		,
		Nome_Tp_Tx Varchar(100),
		Origem	Varchar(100),
		Destino Varchar(100)
		)

Insert @Table(Grupo,Cliente, Num_Proc,NF,mes,ano,Nome_Tp_Tx )
Select 
	PP.Apelido,CL.apelido,Num_Proc_Hia,sum(dbo.valor(vlr_pgto_nf_hia,dc_hia)),
	month(emissao) Mes,year(emissao) Mes ,Nome_Tp_Tx 
From vwcta_cte cta with(nolock)
Join Base_Nota_Fiscal NF with(nolock) on num_nf_hia=notA_fiscal and ref_acesso_nf_hia=ref_Acesso
Join vwcliente C with(nolock) on C.num_proc=cta.num_proc_hia
Join PessoA_LLP PLL with(nolock) on pll.cd_pes=cd_cliente
Left Join Pessoa PP with(nolock) on pP.cd_pes=PLL.cd_pes_grupo --and cd_pes_Grupo <> 'GRATL'
Join Pessoa CL with(nolock) on CL.cd_pes=cd_cliente
Join Tipo_Taxa TT with(nolock) on TT.Cd_Tp_Tx=cta.Cd_Tp_Tx 
where
	emissao between @DataInicial and @DataFinal
	and (pp.apelido = @Grupo or @Grupo='')
	
group by PP.Apelido,CL.apelido,Num_Proc_Hia,Nome_Tp_Tx, 
month(emissao) ,year(emissao) 
OPTION (HASH JOIN)
insert @Table
Select PP.Apelido,CL.apelido,cxa.Num_Proc_Hia,0,sum(dbo.valor(Vlr_pgto_Rcto_hia,cxa.dc_hia)),0,
month(convert(Datetime,dt_pgto_rcto_hia,105) ),year(convert(Datetime,dt_pgto_rcto_hia,105) ),Nome_Tp_Tx,null,null   from vwcxas CXA with(nolock)
Join vwcta_cte cta with(nolock) on cta.num_proc_hia=cxa.num_proc_hia and cta.dc_hia=cxa.dc_hia and cta.cd_tp_tx=cxa.cd_tp_Tx
Left Join Base_Nota_Fiscal NF with(nolock) on num_nf_hia=notA_fiscal and ref_acesso_nf_hia=ref_Acesso
Join vwcliente C with(nolock) on C.num_proc=cta.num_proc_hia
Join PessoA_LLP PLL with(nolock) on pll.cd_pes=cd_cliente
Left Join Pessoa PP with(nolock) on pP.cd_pes=PLL.cd_pes_grupo --and cd_pes_Grupo <> 'GRATL'
Join Pessoa CL with(nolock) on CL.cd_pes=cd_cliente
Join Tipo_Taxa TT with(nolock) on TT.Cd_Tp_Tx=cta.Cd_Tp_Tx 
where
	convert(Datetime,dt_pgto_rcto_hia,105) between @DataInicial and @DataFinal
	and emissao is null  and cxa.dc_hia='C'
	and (pp.apelido = @Grupo or @Grupo='')

group by Nome_tp_Tx, PP.Apelido,CL.apelido,cxa.Num_Proc_Hia,year(convert(Datetime,dt_pgto_rcto_hia,105) ),month(convert(Datetime,dt_pgto_rcto_hia,105) )
OPTION (HASH JOIN)
insert @Table
select PP.Apelido,CL.apelido,RFI.num_proc,0,0,sum(dbo.valor(Isnull(RFi.valor_total_Moeda_Local,RFI.Valor_Total),RFI.DC)),RF.mes,RF.Ano,Nome_Tp_Tx,null,null  from registro_financeiro rf with(nolock)
Join Registro_financeiro_item RFI with(nolock) on rfi.num_registro=rf.num_registro and RFI.ano=rf.ano and rfi.mes=rf.mes and ativo='1'
Join vwcliente C with(nolock) on C.num_proc=RFI.num_proc
Join PessoA_LLP PLL with(nolock) on pll.cd_pes=cd_cliente
Left Join Pessoa PP with(nolock) on pP.cd_pes=PLL.cd_pes_grupo --and cd_pes_Grupo <> 'GRATL'
Join Pessoa CL with(nolock) on CL.cd_pes=cd_cliente
Join Tipo_Taxa TT with(nolock) on TT.Cd_Tp_Tx=rfi.Cd_Tp_Tx 
where
	dt_ins between @DataInicial and @DataFinal
	 
	and 
	(pp.apelido = @Grupo or @Grupo='')

group by PP.Apelido,CL.apelido,RFI.num_proc,rf.ano,rf.mes,Nome_Tp_Tx 
OPTION (HASH JOIN)
Update @Table set Origem = cd_org_hia,destino=cd_dst_hia  from @Table
Join House_Imp_Aer hou with(nolock) on hou.Num_Proc_HIA = Num_Proc 

Update @Table set Origem = cd_org_him,destino=cd_dst_him  from @Table
Join House_Imp_Mar  hou with(nolock) on hou.Num_Proc_HIm = Num_Proc 

Update @Table set Origem = cd_org_hea,destino=cd_dst_hea  from @Table
Join House_exp_Aer hou with(nolock) on hou.Num_Proc_HeA = Num_Proc 

Update @Table set Origem = cd_org_hem,destino=cd_dst_hem  from @Table
Join House_exp_Mar  hou with(nolock) on hou.Num_Proc_Hem = Num_Proc 

Update @Table set Origem = cd_org_hio,destino=cd_dst_hio  from @Table
Join House_imp_out hou with(nolock) on hou.Num_Proc_Hio = Num_Proc 

Update @Table set Origem = cd_org_heo,destino=cd_dst_heo  from @Table
Join House_exp_out  hou with(nolock) on hou.Num_Proc_Heo = Num_Proc 

Update @Table set Origem = Nome_Local  from @Table
Join Localidade hou with(nolock) on Origem = Cd_Local 


Update @Table set Destino = Nome_Local  from @Table
Join Localidade hou with(nolock) on Destino = Cd_Local 

select Grupo,cliente,Num_Proc,NF,GrossBilling,Costs,NF+Costs [Net Revenue],mes,ano,Nome_Tp_Tx,Origem,destino  from @Table

GO
