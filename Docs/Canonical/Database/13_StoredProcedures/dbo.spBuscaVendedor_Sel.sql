SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE Procedure [dbo].[spBuscaVendedor_Sel]
		@Num_Proc	Varchar(16),
		@Origem		Varchar(30),
		@Destino	Varchar(30),
		@Cliente	Varchar(40),
		@data		DAtetime

AS

--Rotina para Buscar o Vendedor e informar no Job 

Declare @cd_grupo	VArchar(30)
SEt @Cd_Grupo=(select cd_pes_grupo from grupo where grupo=substring(@num_proc,3,3))

select 
	nome_usuario,US.cd_usuario
from 
	customer_profile
	Join Usuario  US on US.cd_usuario=cd_vendedor
	Join Localidade Org on Org.cd_local=cd_org
	Join Localidade Dst on Dst.cd_local=cd_dst
	Join Pessoa PP on PP.cd_pes=cd_cliente
Where
	(apelido=@Cliente or cd_cliente=@cd_grupo)
	and dt_vencimento >=@data
	and Org.nome_local=@origem and DST.nome_local=@Destino
	
Union All

select 
	nome_usuario,US.cd_usuario
from 
	customer_profile
	Join Usuario  US on US.cd_usuario=cd_vendedor
	Join Localidade Org on Org.cd_local=cd_org
	Join Localidade Dst on Dst.cd_local=cd_dst
	Join Pessoa PP on PP.cd_pes=cd_cliente
Where
	(apelido=@Cliente or cd_cliente=@cd_grupo)
	and dt_vencimento >=@data
	and cd_org='ALL' and DST.nome_local=@Destino
	and Cd_Tipo_Servico='B'


union all


select 
	nome_usuario,US.cd_usuario
from 
	customer_profile
	Join Usuario  US on US.cd_usuario=cd_vendedor
	Join Localidade Org on Org.cd_local=cd_org
	Join Localidade Dst on Dst.cd_local=cd_dst
	Join Pessoa PP on PP.cd_pes=cd_cliente
Where
	(apelido=@Cliente or cd_cliente=@cd_grupo)
	and dt_vencimento >=@data
	and Org.nome_local=@origem and cd_dst='ALL'
	and Cd_Tipo_Servico='B'



GO
