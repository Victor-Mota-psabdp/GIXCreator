SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE Procedure spPropEA_Rel
		@datainicial varchar(10),
		@datafinal varchar(10),
		@usuario varchar(20)
AS

select 
	'Exportação Aérea' Modal,nome_usuario,isdate(convert(datetime,dt_fchto_pea,105)) Situacao,count(num_prop_ea) Qty 

from 
	proposta_exp_aer prop

	inner join usuario on (usuario.cd_usuario=prop.cd_usuario)	

where 
	convert(datetime,dt_pea,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)
	and nome_usuario like @usuario
group by 
	
	nome_usuario,isdate(convert(datetime,dt_fchto_pea,105))

UNION ALL


select 
	'Importação Aérea' Modal,nome_usuario,isdate(convert(datetime,dt_fchto_pia,105)) Situacao,count(num_prop_ia) Qty 

from 
	proposta_iMP_aer prop

	inner join usuario on (usuario.cd_usuario=prop.cd_usuario)	

where 
	convert(datetime,dt_pia,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)
	and nome_usuario like @usuario
group by 
	
	nome_usuario,isdate(convert(datetime,dt_fchto_pIa,105))

UNION ALL

select 
	'Exportação Marítima' Modal,nome_usuario,isdate(convert(datetime,dt_fchto_pem,105)) Situacao,count(num_prop_em) Qty 

from 
	proposta_exp_mar prop

	inner join usuario on (usuario.cd_usuario=prop.cd_usuario)	

where 
	convert(datetime,dt_pem,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)
	and nome_usuario like @usuario
group by 
	
	nome_usuario,isdate(convert(datetime,dt_fchto_pem,105))

UNION ALL


select 
	'Importação Marítima' Modal,nome_usuario,isdate(convert(datetime,dt_fchto_pim,105)) Situacao,count(num_prop_im) Qty 

from 
	proposta_iMP_mar prop

	inner join usuario on (usuario.cd_usuario=prop.cd_usuario)	

where 
	convert(datetime,dt_pim,105) between convert(datetime,@datainicial,105) and convert(datetime,@datafinal,105)
	and nome_usuario like @usuario
group by 
	
	nome_usuario,isdate(convert(datetime,dt_fchto_pIm,105))


GO
