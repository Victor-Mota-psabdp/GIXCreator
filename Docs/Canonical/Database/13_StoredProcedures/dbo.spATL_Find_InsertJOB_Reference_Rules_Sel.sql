SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

/*
Comentarios
If alterado (left(@Num_Proc,2) or JRR.Modal = 'AL') em 11/09 por Leandro
*/

CREATE procedure [dbo].[spATL_Find_InsertJOB_Reference_Rules_Sel]
	
	@Num_Proc			varchar(16),
	@Numero_PO			varchar(80),
	@ID_DC				int

AS

	Declare @Cd_Grupo varchar(10)      
	set @Cd_Grupo = (select Cd_Pes_Grupo from Pessoa_LLP LLP with(nolock) 
	join vwCliente VW with(nolock) on vw.cd_cliente = llp.cd_pes
	where VW.num_proc = @Num_Proc)

	


	--if exists(select ID from InsertJOB_Reference_Rules where Cd_Pes_Grupo = @Cd_Grupo and Modal = left(@Num_Proc,2) and ID_DC=@ID_DC and [Status] = 1)
	if exists(select ID from InsertJOB_Reference_Rules JRR where Cd_Pes_Grupo = @Cd_Grupo and (JRR.Modal = left(@Num_Proc,2) or JRR.Modal = 'AL') and ID_DC=@ID_DC and [Status] = 1)
		BEGIN
			DECLARE @Cd_Shipper VARCHAR(10);

			IF LEFT(@Num_Proc, 1) = 'I'
				BEGIN
					SET @Cd_Shipper = (SELECT cd_fornecedor 
									   FROM vwClienteALLJOBS VW WITH (NOLOCK) 
									   WHERE VW.num_proc = @Num_Proc);
				END
			ELSE IF LEFT(@Num_Proc, 1) = 'E'
				BEGIN
					SET @Cd_Shipper = (SELECT cd_cliente 
									   FROM vwClienteALLJOBS VW WITH (NOLOCK) 
									   WHERE VW.num_proc = @Num_Proc);
				END

				IF LEFT(@Num_Proc, 1) = 'E'
					BEGIN
						select distinct PO.Num_Proc, HOU.Cd_Export, PO.Numero_PO, PO.ID_DC,@Cd_Grupo [Grupo] from vwHouse_Exp HOU
						Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Export
						join InsertJOB_Reference_Rules JRR with(nolock) on JRR.Cd_Pes_Grupo = PLL.Cd_Pes_Grupo
						--join vwPO_ALL PO with(nolock) on PO.num_proc = HOU.num_proc and left(po.Num_Proc,1) = JRR.Modal and PO.ID_DC = jrr.ID_DC
						join vwPO_ALL PO with(nolock) on PO.num_proc = HOU.num_proc and PO.ID_DC = jrr.ID_DC
						where 
							JRR.Cd_Pes_Grupo = @Cd_Grupo						
							and PO.Numero_PO = @Numero_PO
							and PO.ID_DC = @ID_DC
							and HOU.Cd_Export = @Cd_Shipper
							and PO.num_proc not in (@Num_Proc)
					END

				ELSE IF LEFT(@Num_Proc, 1) = 'I'	
					BEGIN
						select distinct PO.Num_Proc, HOU.Cd_Export, PO.Numero_PO, PO.ID_DC,@Cd_Grupo [Grupo] from vwHouse_Imp HOU
						Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig
						join InsertJOB_Reference_Rules JRR with(nolock) on JRR.Cd_Pes_Grupo = PLL.Cd_Pes_Grupo
						--join vwPO_ALL PO with(nolock) on PO.num_proc = HOU.num_proc and left(po.Num_Proc,1) = JRR.Modal and PO.ID_DC = jrr.ID_DC
						join vwPO_ALL PO with(nolock) on PO.num_proc = HOU.num_proc and PO.ID_DC = jrr.ID_DC 
					
						where 
							JRR.Cd_Pes_Grupo = @Cd_Grupo						
							and PO.Numero_PO = @Numero_PO
							and PO.ID_DC = @ID_DC	
							and HOU.Cd_Export = @Cd_Shipper
							and PO.num_proc not in (@Num_Proc)
					
					END	


		END
	ELSE
		BEGIN
			select NULL Num_Proc, NULL Cd_Export, NULL Numero_PO, NULL ID_DC,NULL [Grupo]  FROM vwClienteALLJOBS VW WITH (NOLOCK) WHERE VW.num_proc = ''
		END

--Comentado em 11/10/2024 Leandro
--USE [Atlantis]
--GO
--/****** Object:  StoredProcedure [dbo].[spATL_Find_RefRules_Sel]    Script Date: 11/10/2024 10:02:15 ******/
--SET ANSI_NULLS ON
--GO
--SET QUOTED_IDENTIFIER ON
--GO
--ALTER procedure [dbo].[spATL_Find_RefRules_Sel] --'IMOXT202302001BR','1',2
	
--	@Num_Proc			varchar(16),
--	@Numero_PO			varchar(80),
--	@ID_DC				int

--AS
--	BEGIN
--			IF LEFT(@Num_Proc, 2) = 'IM'

--				BEGIN
--					select PO.Num_Proc, PO.Numero_PO, PO.ID_DC from vwHouse_Imp  HOU with(nolock)
--					join vwPO_ALL PO with(nolock) on PO.num_proc = HOU.num_proc
--					Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig
--					join InsertJOB_Reference_Rules JRR with(nolock) on JRR.Cd_Pes_Grupo = PLL.Cd_Pes_Grupo
--					where PO.num_Proc like left(@Num_Proc,5)+'%'
--					and PO.Numero_PO = @Numero_PO
--					and JRR.ID_DC = PO.ID_DC
--				END

--			IF LEFT(@Num_Proc, 2) = 'IA'

--				BEGIN
--					select PO.Num_Proc, PO.Numero_PO, PO.ID_DC from vwHouse_Imp  HOU with(nolock)
--					join vwPO_ALL PO with(nolock) on PO.num_proc = HOU.num_proc
--					Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig
--					join InsertJOB_Reference_Rules JRR with(nolock) on JRR.Cd_Pes_Grupo = PLL.Cd_Pes_Grupo
--					where PO.num_Proc like left(@Num_Proc,5)+'%'
--					and PO.Numero_PO = @Numero_PO
--					and JRR.ID_DC = PO.ID_DC
--				END

--			IF LEFT(@Num_Proc, 2) = 'IO'

--				BEGIN
--					select PO.Num_Proc, PO.Numero_PO, PO.ID_DC from vwHouse_Imp  HOU with(nolock)
--					join vwPO_ALL PO with(nolock) on PO.num_proc = HOU.num_proc
--					Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig
--					join InsertJOB_Reference_Rules JRR with(nolock) on JRR.Cd_Pes_Grupo = PLL.Cd_Pes_Grupo
--					where PO.num_Proc like left(@Num_Proc,5)+'%'
--					and PO.Numero_PO = @Numero_PO
--					and JRR.ID_DC = PO.ID_DC
--				END

--			IF LEFT(@Num_Proc, 2) = 'EM'

--				BEGIN
--					select PO.Num_Proc, PO.Numero_PO, PO.ID_DC from vwHouse_Exp  HOU with(nolock)
--					join vwPO_ALL PO with(nolock) on PO.num_proc = HOU.num_proc
--					Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig
--					join InsertJOB_Reference_Rules JRR with(nolock) on JRR.Cd_Pes_Grupo = PLL.Cd_Pes_Grupo
--					where PO.num_Proc like left(@Num_Proc,5)+'%'
--					and PO.Numero_PO = @Numero_PO
--					and JRR.ID_DC = PO.ID_DC
--				END

--			IF LEFT(@Num_Proc, 2) = 'EA'

--				BEGIN
--					select PO.Num_Proc, PO.Numero_PO, PO.ID_DC from vwHouse_Exp  HOU with(nolock)
--					join vwPO_ALL PO with(nolock) on PO.num_proc = HOU.num_proc
--					Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig
--					join InsertJOB_Reference_Rules JRR with(nolock) on JRR.Cd_Pes_Grupo = PLL.Cd_Pes_Grupo
--					where PO.num_Proc like left(@Num_Proc,5)+'%'
--					and PO.Numero_PO = @Numero_PO
--					and JRR.ID_DC = PO.ID_DC
--				END

--			IF LEFT(@Num_Proc, 2) = 'EO'

--				BEGIN
--					select PO.Num_Proc, PO.Numero_PO, PO.ID_DC from vwHouse_Exp  HOU with(nolock)
--					join vwPO_ALL PO with(nolock) on PO.num_proc = HOU.num_proc
--					Join Pessoa_LLP PLL  with(nolock) on PLL.Cd_Pes=HOU.Cd_Consig
--					join InsertJOB_Reference_Rules JRR with(nolock) on JRR.Cd_Pes_Grupo = PLL.Cd_Pes_Grupo
--					where PO.num_Proc like left(@Num_Proc,5)+'%'
--					and PO.Numero_PO = @Numero_PO
--					and JRR.ID_DC = PO.ID_DC
--				END
--	END



GO
