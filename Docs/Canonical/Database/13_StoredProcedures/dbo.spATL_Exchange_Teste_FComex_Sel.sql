SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[spATL_Exchange_Teste_FComex_Sel]
(		@Exchange_id bigint,
		@Id_Empresa  bigint,
        @Num_Proc   varchar(16),
        @Processo   varchar(16),
		@Tipo		varchar(1)
)
as
/* Tipo de Processo 
   A todos processos nao encerrados ate o momento lidos ou não  

   02-01-2026 - anonio mudei a opção B  
   B todos processos nao encerrados ate o momento lidos ou não por empresa 
     mudei a situacao para pegar fora do where os jobs que forem incluidaos na mão 
   
   19-02-2025  Antonio 
	   1 - trazer somente os jobs que estão diferentes de 
	   BDP <> Conclusão Operacional 
	   Piberant  <> Faturado 
       2 - fazer um join pegando o que esta sem data de atualização no ATL = null na tabela
	   ATL_INT.dbo.JSON_FComex_JobReferences_Line com status 
	   BDP = Conclusão Operacional 
	   Pibernat = Faturado 

   C processo unico por id
   D todos documentos dos processos nao encerrados ate o momento e que não estejam preeenchidos o <string64> 
   E todos documentos dos processos nao encerrados ate o 
     momento e que não estejam preeenchidos o <string64> separados por empresa
   L pegar por lote de jobs e processar -  colocar os jobs desejados    
   P processos pelo numproc do fcomex  
   Q trazer qualquer processo encerrado ou não para mostra na tela de integração 
   R trazer qualquer processo encerrado ou não para mostra na tela de integração, 
   no caso da Pibernt o numero é o processo e  tem que ver se ja não tem cadastrado 

*/
if @Tipo ='A'
	BEGIN
		select 
   			e.Exchange_id,
			e.Num_Proc,
			e.Processo,
			e.Lido_Processo,
			e.Dt_Leitura_Processo,
			e.Dt_Fim_Processo,
			0 [id_processo],
			'' [Processo_ATL],
			e.Id_Empresa,
			0 [Item_Id]
			,HOU.ID_status
			from ATL_INT.dbo.Exchange_FComex e with(nolock)
			join VwHouse_Imp HOU with(nolock) on HOU.Num_Proc = E.Num_proc
		    where convert(datetime, e.Dt_Leitura_Processo, 103) < convert(datetime, GETDATE(), 103)
--				 and e.Dt_Fim_Processo is null
	END

if @Tipo ='B'
	BEGIN
	    if @Id_Empresa =1 --BDP
           Begin 
				select 
   					e.Exchange_id,
					e.Num_Proc,
					e.Processo,
					e.Lido_Processo,
					e.Dt_Leitura_Processo,
					e.Dt_Fim_Processo,
					0 [id_processo],
					'' [Processo_ATL],
					e.Id_Empresa,
					0 [Item_Id]
					,HOU.ID_status
					,j.situacao
					,j.Id_Processo
					from ATL_INT.dbo.Exchange_FComex e with(nolock)
					join VwHouse_Imp HOU with(nolock) on HOU.Num_Proc = E.Num_proc
					left join ATL_INT.dbo.JSON_FComex_JobReferences_Line j with(nolock) 
					on J.Num_proc = E.Num_proc and J.Processo = E.Processo
					where 
					convert(datetime, e.Dt_Leitura_Processo, 103) < convert(datetime, GETDATE(), 103) --convert(datetime,DATEADD(MINUTE,-10,GETDATE()), 103)
					and e.Id_Empresa = @Id_Empresa	
					-- 07-11-2025 antonio -  cadu pediu para comentar 
					--and isnull(HOU.ID_status,0) < 8	
					and j.situacao not like '%Cancelado%' 
					and j.situacao  <> 'Num_Proc not Found!'	
					and j.Situacao <> 'Conclusão Operacional'
              Union       
				select 
   					e.Exchange_id,
					e.Num_Proc,
					e.Processo,
					e.Lido_Processo,
					e.Dt_Leitura_Processo,
					e.Dt_Fim_Processo,
					0 [id_processo],
					'' [Processo_ATL],
					e.Id_Empresa,
					0 [Item_Id]
					,HOU.ID_status
					,j.situacao
					,j.Id_Processo
					from ATL_INT.dbo.Exchange_FComex e with(nolock)
					join VwHouse_Imp HOU with(nolock) on HOU.Num_Proc = E.Num_proc
					left join ATL_INT.dbo.JSON_FComex_JobReferences_Line j with(nolock) 
					on J.Num_proc = E.Num_proc and J.Processo = E.Processo
					where 
					convert(datetime, e.Dt_Leitura_Processo, 103) < convert(datetime, GETDATE(), 103) --convert(datetime,DATEADD(MINUTE,-10,GETDATE()), 103)
					and e.Id_Empresa = @Id_Empresa	
					-- 07-11-2025 antonio -  cadu pediu para comentar 
					--and isnull(HOU.ID_status,0) < 8	
					and j.Dt_Ins_Atl is null
					and j.situacao not like '%Cancelado%' 
					and j.situacao  <> 'Num_Proc not Found!'	
					and j.Situacao = 'Conclusão Operacional'
			end 
	    if @Id_Empresa =2 --Pibernat 
           Begin 
				select 
   					e.Exchange_id,
					e.Num_Proc,
					e.Processo,
					e.Lido_Processo,
					e.Dt_Leitura_Processo,
					e.Dt_Fim_Processo,
					0 [id_processo],
					'' [Processo_ATL],
					e.Id_Empresa,
					0 [Item_Id]
					,HOU.ID_status
					,j.situacao
					,j.Id_Processo
					from ATL_INT.dbo.Exchange_FComex e with(nolock)
					join VwHouse_Imp HOU with(nolock) on HOU.Num_Proc = E.Num_proc
					left join ATL_INT.dbo.JSON_FComex_JobReferences_Line j with(nolock) 
					on J.Num_proc = E.Num_proc and J.Processo = E.Processo
					where 
					convert(datetime, e.Dt_Leitura_Processo, 103) < convert(datetime, GETDATE(), 103) --convert(datetime,DATEADD(MINUTE,-10,GETDATE()), 103)
					and e.Id_Empresa = @Id_Empresa	
					-- 07-11-2025 antonio -  cadu pediu para comentar 
					--and isnull(HOU.ID_status,0) < 8	
				    and j.situacao not like '%Cancelado%' 
					and j.situacao  <> 'Num_Proc not Found!'	
					and j.Situacao <> 'Faturado'
	              Union       
				select 
   					e.Exchange_id,
					e.Num_Proc,
					e.Processo,
					e.Lido_Processo,
					e.Dt_Leitura_Processo,
					e.Dt_Fim_Processo,
					0 [id_processo],
					'' [Processo_ATL],
					e.Id_Empresa,
					0 [Item_Id]
					,HOU.ID_status
					,j.situacao
					,j.Id_Processo
					from ATL_INT.dbo.Exchange_FComex e with(nolock)
					join VwHouse_Imp HOU with(nolock) on HOU.Num_Proc = E.Num_proc
					left join ATL_INT.dbo.JSON_FComex_JobReferences_Line j with(nolock) 
					on J.Num_proc = E.Num_proc and J.Processo = E.Processo
				where 
					convert(datetime, e.Dt_Leitura_Processo, 103) < convert(datetime, GETDATE(), 103) --convert(datetime,DATEADD(MINUTE,-10,GETDATE()), 103)
					and e.Id_Empresa = @Id_Empresa	
					-- 07-11-2025 antonio -  cadu pediu para comentar 
					--and isnull(HOU.ID_status,0) < 8	
					and j.Dt_Ins_Atl is null
					and j.situacao not like '%Cancelado%' 
					and j.situacao  <> 'Num_Proc not Found!'	
					and j.Situacao = 'Faturado'
				end 
  	END

if @Tipo ='C'
	BEGIN
		select 
				Exchange_id,
				Num_Proc,
				Processo,
				Lido_Processo,
				Dt_Leitura_Processo,
				Dt_Fim_Processo,
				0 [id_processo],
   			'' [Processo_ATL],
 				[Id_Empresa],
				0 [Item_Id]
		from ATL_INT.dbo.Exchange_FComex with(nolock)
		where Exchange_id = @Exchange_id
--			and Dt_Fim_Processo is null	

	END

if @Tipo ='D'
	BEGIN
			select 
				e.Exchange_id,
				e.Num_Proc,
				e.Processo,
				e.Dt_Fim_Processo,
				e.Lido_Processo,
				e.Dt_Leitura_Processo,
				j.Id_Processo,
	   			'' [Processo_ATL],
				j.[Id_Empresa],
				d.Id_Item [Item_Id]
		from ATL_INT.dbo.Exchange_FComex e with(nolock)
			    join ATL_INT.dbo.JSON_FComex_JobReferences_Line j with(nolock) on j.Processo = e.Processo
                join ATL_INT.dbo.JSON_FComex_Documento_Line d  with(nolock)  on d.Id_Processo = j.Id_Processo  
 					and d.FileName <> '' 
 					and d.[File]=''
--          where   e.Dt_Fim_Processo is null	
        order by id_empresa asc       
	END

if @Tipo ='E'
	BEGIN
		select 
			e.Exchange_id,
			e.Num_Proc,
			e.Processo,
			e.Dt_Fim_Processo,
			e.Lido_Processo,
			e.Dt_Leitura_Processo,
			j.Id_Processo,
	   		'' [Processo_ATL],
			j.[Id_Empresa],
			d.Id_Item [Item_Id]	,
			D.Dt_ins_ATL,
			isnull(d.FileName,'') FileName,
			J.Situacao
		from ATL_INT.dbo.Exchange_FComex e with(nolock)
		join ATL_INT.dbo.JSON_FComex_JobReferences_Line j with(nolock) on J.Num_proc = E.Num_proc and J.Processo = E.Processo --j  with(nolock)  on j.Processo = e.Processo
		join VwHouse_Imp HOU with(nolock) on HOU.Num_Proc = E.Num_proc
        join ATL_INT.dbo.JSON_FComex_Documento_Line d  with(nolock)  on d.Id_Processo = j.Id_Processo	
		where
		e.Id_Empresa = @Id_Empresa
		and isnull(d.FileName,'') <> ''
		and d.FileFullPath is null
		and D.Dt_ins_ATL is null
        order by j.Id_Processo,E.num_proc
		--id_empresa asc       
	END
 
 if @Tipo ='L' --Mesma ideia do Q, mas este faz por lote ( num_proc in (..,..,..))
	BEGIN
		select 
				e.Exchange_id,
                e.Num_Proc, 
				e.Processo,
				e.Lido_Processo,
				e.Dt_Leitura_Processo,
				e.Dt_Fim_Processo,
	   		    '' [Processo_ATL],
				e.Id_Empresa [Id_Empresa],
				isnull(j.id_processo,0) [Id_Processo], 
 				0 [Item_Id]
		from ATL_INT.dbo.Exchange_FComex e with(nolock)
		left join atl_int.dbo.JSON_FComex_JobReferences_Line j with(nolock)	on j.Num_Proc = e.Num_Proc
		where e.Num_Proc in ('IMSOL202511012BR',
							'IMSOL202511046BR',
							'IMSOL202511047BR',
							'IMSOL202511037BR',
							'IMSOL202511038BR',
							'IMSOL202512016BR',
							'IMSOL202510053BR',
							'IMSOL202510067BR',
							'IMSOL202510118BR')
	END
if @Tipo ='P'
	BEGIN
		select 
				Exchange_id,
				Num_Proc,
				processo,
				Lido_Processo,
				Dt_Leitura_Processo,
				Dt_Fim_Processo,
				0 [id_processo],
 	   		'' [Processo_ATL],
				[Id_Empresa],
				0 [Item_Id]
		from ATL_INT.dbo.Exchange_FComex with(nolock)
		where num_proc = @Num_Proc
--			and Dt_Fim_Processo is null	
	END


if @Tipo ='Q'
	BEGIN
		select 
				e.Exchange_id,
                e.Num_Proc, 
				e.Processo,
				e.Lido_Processo,
				e.Dt_Leitura_Processo,
				e.Dt_Fim_Processo,
	   		    '' [Processo_ATL],
				e.Id_Empresa [Id_Empresa],
				isnull(j.id_processo,0) [Id_Processo], 
 				0 [Item_Id]
		from ATL_INT.dbo.Exchange_FComex e with(nolock)
		left join atl_int.dbo.JSON_FComex_JobReferences_Line j with(nolock)	on j.Num_Proc = e.Num_Proc
		where e.Num_Proc = @Num_Proc
	END

if @Tipo ='R'
	BEGIN
		select 
				e.Exchange_id,
                e.Num_Proc, 
				e.Processo,
				e.Lido_Processo,
				e.Dt_Leitura_Processo,
				e.Dt_Fim_Processo,
	   		    '' [Processo_ATL],
				e.Id_Empresa [Id_Empresa],
				isnull(j.id_processo,0) [Id_Processo], 
 				0 [Item_Id]
		from ATL_INT.dbo.Exchange_FComex e with(nolock)
		left join atl_int.dbo.JSON_FComex_JobReferences_Line j with(nolock)	on j.Num_Proc = e.Num_Proc
		where e.Processo = @Processo
	END


if @Tipo ='S'
	BEGIN
		select 
   			--e.Exchange_id,
			j.Id_Processo Exchange_id,
			NULL Num_Proc,
			NULL Processo,
			convert(bit,0) Lido_Processo,
			NULL Dt_Leitura_Processo,
			NULL Dt_Fim_Processo,
			0 [id_processo],
			'' [Processo_ATL],
			J.Id_Empresa Id_Empresa,
			0 [Item_Id]
			--,HOU.ID_status
			,j.situacao
			,j.Id_Processo
			from ATL_INT.dbo.JSON_FComex_JobReferences_Line j 
			--from ATL_INT.dbo.Exchange_FComex e with(nolock)
			--join VwHouse_Imp HOU with(nolock) on HOU.Num_Proc = E.Num_proc
			--left join ATL_INT.dbo.JSON_FComex_JobReferences_Line j with(nolock) on J.Num_proc = E.Num_proc-- and J.Processo = E.Processo
		    where 
		--	convert(datetime, e.Dt_Leitura_Processo, 103) < convert(datetime, GETDATE(), 103) --convert(datetime,DATEADD(MINUTE,-10,GETDATE()), 103)
		--and 
			J.Id_Empresa = @Id_Empresa		
			and j.situacao is null
			
				 
				 
  	END

GO
