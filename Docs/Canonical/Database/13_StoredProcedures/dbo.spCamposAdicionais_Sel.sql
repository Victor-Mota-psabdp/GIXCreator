SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--[spCamposAdicionais_Sel] 'IMSLT201102002AR'
--[spCamposAdicionais_Sel] 'IMBUE201103001'
--select * from tipo_campo_cliente
--select * from tipo_campo_cliente_modais 


CREATE procedure [dbo].[spCamposAdicionais_Sel]
(
@JOB varchar(16)
)
as

	Declare @Grupo Varchar (20)

	set @Grupo=(select top 1 cd_pes_grupo from vwcliente with (nolock) join pessoa_llp p with(nolock) on p.cd_pes=cd_cliente and num_proc=@Job)
	
	select tcc.id_campo,
		Descr_Campo, isnull(Campo_Dados,'') Campo_Dados, Tab_Relacionada, Cod_Busca, Campo_Exibicao 
	from tipo_campo_cliente TCC with (nolock)
		left join Campo_Processo CP with (nolock) on TCC.Id_Campo=CP.Id_Campo and Num_Proc=@JOB
--		Join Grupo G on G.cd_pes_grupo=TCC.cd_pes_grupo  
		join tipo_campo_cliente_modais M with (nolock) on M.id_campo = TCC.id_campo
	where
		TCC.cd_pes_grupo in ('10017',@Grupo) and TCC.Tipo <> 'X'
		and (( len(@JOB)=16 and M.house=1) or (len(@JOB)=14 and M.master=1 ))
		and ((left(@JOB,1) = 'E' and Export = '1') or (left(@JOB,1) = 'I' and Import = '1'))
		and ((substring(@JOB,2,1) = 'A' and Air = '1') or (substring(@JOB,2,1) = 'M' and Ocean = '1') or (substring(@JOB,2,1) = 'O' and Other = '1'))
		
	order by
		Descr_Campo


--estava assim, porém estava trazendo todos os casos, não importando o modal, voltei ao antigo q era o usado no atl_khda
--
--ALTER procedure [dbo].[spCamposAdicionais_Sel]
--(
--@JOB varchar(16)
--)
--as
--
--	Declare @Grupo Varchar (20)
--
--	set @Grupo=(select top 1 cd_pes_grupo from vwcliente join pessoa_llp p with(nolock) on p.cd_pes=cd_cliente and num_proc=@Job)
--	
--	select tcc.id_campo,
--		Descr_Campo, isnull(Campo_Dados,'') Campo_Dados, Tab_Relacionada, Cod_Busca, Campo_Exibicao 
--	from tipo_campo_cliente TCC
--		left join Campo_Processo CP on TCC.Id_Campo=CP.Id_Campo and Num_Proc=@JOB
----		Join Grupo G on G.cd_pes_grupo=TCC.cd_pes_grupo  
--		join tipo_campo_cliente_modais M on M.id_campo = TCC.id_campo
--	where
--		TCC.cd_pes_grupo in ('10017',@Grupo) and TCC.Tipo <> 'X'
--		and ( 
--				( len(@JOB)=16 and M.house=1) or (len(@JOB)=14 and M.master=1 )
--			)
--		
--	order by
--		Descr_Campo







GO
