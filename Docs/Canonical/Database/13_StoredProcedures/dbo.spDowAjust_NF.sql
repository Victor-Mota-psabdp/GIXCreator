SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure spDowAjust_NF

as



select distinct ps.num_proc from pedido_ship PS
Join NotA_cliente NC on NC.num_proc=PS.num_proc
Left Join Nota_Fiscal_Cliente_Det NCD on NCD.id_nf=NC.id_nf and NCD.cd_cliente=NC.cd_cliente and NCD.cd_produto=ps.cd_produto
where PS.num_proc in(

Select num_proc From pedido_ship
Join Produto_Cliente PC on cd_prod=cd_produto
where
	substring(num_proc,3,3) in ('CSR','ROB','STB')
	and left(num_proc,1)='I'
group by
	num_proc
having
	count(distinct cd_prod)=1
	
)
and NCD.id_nf is null
GO
