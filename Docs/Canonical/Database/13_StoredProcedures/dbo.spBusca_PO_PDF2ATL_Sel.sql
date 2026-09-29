SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--incluido buscar p o grupo solenis, pelo numero do po:100-110978
--13//07/2023 - Cadu, alterado p usar a view
CREATE procedure [dbo].[spBusca_PO_PDF2ATL_Sel]--'4533341567','SOL'
(
	@Documento varchar(50),
	@cd_grupo varchar(3)
)
as

	IF @cd_grupo in ('CSR', 'BCB')		
			select Num_Proc_HEA Processo from PO_HEA  with(nolock) 
				where Numero_PO_HEA=@Documento and ID_DC=1
				and SUBSTRING(Num_Proc_HEA, 3,3) = @cd_grupo
			union all
			select Num_Proc_HEM  Processo from PO_HEM with(nolock)  
				where Numero_PO_HEM= @Documento and ID_DC=1
				and SUBSTRING(Num_Proc_HEM, 3,3) = @cd_grupo
			union all
			select Num_Proc_HEO Processo  from PO_HEO with(nolock)  
				where Numero_PO_HEO=@Documento and ID_DC=1
				and SUBSTRING(Num_Proc_HEO, 3,3) = @cd_grupo		
		
	ELSE IF @cd_grupo in ('SOL')
			
			select PO.Num_Proc Processo from vwPO_ALL PO  with(nolock) 
				join vwALL_JOBs HOU with(nolock)  on HOU.Num_Proc = PO.Num_Proc
				where 
					PO.Numero_PO=@Documento and PO.ID_DC=1
					and SUBSTRING(PO.Num_Proc, 3,3) = @cd_grupo
					and HOU.ID_Status <> 9

			--select Num_Proc_HIA Processo from PO_HIA  with(nolock) 
			--	where Numero_PO_HIA=@Documento and ID_DC=1
			--	and SUBSTRING(Num_Proc_HIA, 3,3) = @cd_grupo
			--union all
			--select Num_Proc_HIM  Processo from PO_HIM with(nolock)  
			--	where Numero_PO_HIM= @Documento and ID_DC=1
			--	and SUBSTRING(Num_Proc_HIM, 3,3) = @cd_grupo
			--union all
			--select Num_Proc_HIO Processo  from PO_HIO with(nolock)  
			--	where Numero_PO_HIO=@Documento and ID_DC=1
			--	and SUBSTRING(Num_Proc_HIO, 3,3) = @cd_grupo
			--union all	
			--	select Num_Proc_HEA Processo from PO_HEA  with(nolock) 
			--	where Numero_PO_HEA=@Documento and ID_DC=1
			--	and SUBSTRING(Num_Proc_HEA, 3,3) = @cd_grupo
			--union all
			--select Num_Proc_HEM  Processo from PO_HEM with(nolock)  
			--	where Numero_PO_HEM= @Documento and ID_DC=1
			--	and SUBSTRING(Num_Proc_HEM, 3,3) = @cd_grupo
			--union all
			--select Num_Proc_HEO Processo  from PO_HEO with(nolock)  
			--	where Numero_PO_HEO=@Documento and ID_DC=1
			--	and SUBSTRING(Num_Proc_HEO, 3,3) = @cd_grupo
				
	ELSE IF @cd_grupo in ('STL')
		
		
			select num_proc Processo from vwCliente where  num_proc = @Documento and SUBSTRING(num_proc, 3,3) = @cd_grupo
		
			--select Num_Proc_HIA Processo from PO_HIA  with(nolock) 
			--	where Numero_PO_HIA=@Documento and ID_DC=1
			--	and SUBSTRING(Num_Proc_HIA, 3,3) = @cd_grupo
			--union all
			--select Num_Proc_HIM  Processo from PO_HIM with(nolock)  
			--	where Numero_PO_HIM= @Documento and ID_DC=1
			--	and SUBSTRING(Num_Proc_HIM, 3,3) = @cd_grupo
			--union all
			--select Num_Proc_HIO Processo  from PO_HIO with(nolock)  
			--	where Numero_PO_HIO=@Documento and ID_DC=1
			--	and SUBSTRING(Num_Proc_HIO, 3,3) = @cd_grupo
		
				
	ELSE
		
			select PO.Num_Proc Processo from vwPO_ALL PO  with(nolock) 
				join vwALL_JOBs HOU with(nolock)  on HOU.Num_Proc = PO.Num_Proc
				where 
					PO.Numero_PO=@Documento and PO.ID_DC=3
					and SUBSTRING(PO.Num_Proc, 3,3) = @cd_grupo
					and HOU.ID_Status <> 9
			
			--select Num_Proc_HEA Processo from PO_HEA PO  with(nolock) 
			--	join vwHouse_Exp HOU  with(nolock)  on HOU.Num_Proc = PO.Num_Proc_HEA
			--	where 
			--		PO.Numero_PO_HEA=@Documento and PO.ID_DC=3
			--		and SUBSTRING(PO.Num_Proc_HEA, 3,3) = @cd_grupo
			--union all
			--select Num_Proc_HEM  Processo from PO_HEM with(nolock)  
			--	where Numero_PO_HEM= @Documento and ID_DC=3
			--	and SUBSTRING(Num_Proc_HEM, 3,3) = @cd_grupo
			--union all
			--select Num_Proc_HEO Processo  from PO_HEO with(nolock)  
			--	where Numero_PO_HEO=@Documento and ID_DC=3
			--	and SUBSTRING(Num_Proc_HEO, 3,3) = @cd_grupo
			--union all
			--select Num_Proc_HIA Processo from PO_HIA  with(nolock) 
			--	where Numero_PO_HIA=@Documento and ID_DC=3
			--	and SUBSTRING(Num_Proc_HIA, 3,3) = @cd_grupo
			--union all
			--select Num_Proc_HIM  Processo from PO_HIM with(nolock)  
			--	where Numero_PO_HIM= @Documento and ID_DC=3
			--	and SUBSTRING(Num_Proc_HIM, 3,3) = @cd_grupo
			--union all
			--select Num_Proc_HIO Processo  from PO_HIO with(nolock)  
			--	where Numero_PO_HIO=@Documento and ID_DC=3
			--	and SUBSTRING(Num_Proc_HIO, 3,3) = @cd_grupo
		
	
OPTION(HASH JOIN)
GO
