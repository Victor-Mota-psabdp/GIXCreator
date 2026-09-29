SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

--cadu: altera o ano para 365, pois estava como 180 e estava dando o ano atual, so estava funcionando a old
--20-02-2018 - cadu - incluido o esquema do bo
-- [spRManagerv2_MODAL_Sel] '','ALL'
--Cadu
--08-01-2021 - alterei p o old só pegar IM < ano passado
--08-01-2021 - alterei p o IM só pegar IM >= ano passado
--08-01-2021 - alterei p os outros modais pegarem todos os anos
CREATE Procedure [dbo].[spRManagerv2_MODAL_Sel]

@Modal varchar(2),
@Year varchar(4)

as
Declare @ActualYear varchar(4)

--set @ActualYear = YEAR(getdate()-180)
set @ActualYear = YEAR(getdate()) -1

if @Year = 'OLD' 
	Begin
	print @Year
		select distinct upper(excprocesso) job,min(Excdataalt) Data,V.Dt_Criacao,@ActualYear ActualYear from exchange E with(nolock)
			join vwCliente V with(nolock) on V.num_proc = E.ExcProcesso
			left join LLP_BDP_OUT LBO with(nolock) on LBO.Num_Proc_LBO = E.ExcProcesso
			left join JOB_HBO J with(nolock) on J.Num_Proc_HBO =LBO.Num_Proc_LBO 
		where 
			--year(convert(datetime,V.Dt_Criacao,103)) < @ActualYear and
			year(convert(datetime,V.Dt_Criacao,103)) <= @ActualYear and
			 excreportmanager2 is null
			 and substring(excprocesso,1,2) = 'IM'
			and
			(
				J.Num_Proc is null and isnull(LBO.Id_TP_Servico ,0) <> 1	
			)
		group by upper(excprocesso),V.Dt_Criacao
		order by 2
		option(hash join)
	End
	else
		Begin
		if @Year = 'ALL' and @Modal = ''
			Begin
				select distinct upper(excprocesso) job,min(Excdataalt) Data,V.Dt_Criacao,@ActualYear ActualYear from exchange E with(nolock)
					join vwCliente V with(nolock) on V.num_proc = E.ExcProcesso
					left join LLP_BDP_OUT LBO with(nolock) on LBO.Num_Proc_LBO = E.ExcProcesso
					left join JOB_HBO J with(nolock) on J.Num_Proc_HBO =LBO.Num_Proc_LBO 
				where 
					 excreportmanager2 is null
					and
					(
						J.Num_Proc is null and isnull(LBO.Id_TP_Servico ,0) <> 1	
					)
				group by upper(excprocesso),V.Dt_Criacao
				order by 2
				option(hash join)
			End
		else
			if @Year = '' and @Modal <> ''
				Begin
				print @Year
					select distinct upper(excprocesso) job,min(Excdataalt) Data,V.Dt_Criacao,@ActualYear ActualYear from exchange E with(nolock)
						join vwCliente V with(nolock) on V.num_proc = E.ExcProcesso
						left join LLP_BDP_OUT LBO with(nolock) on LBO.Num_Proc_LBO = E.ExcProcesso
						left join JOB_HBO J with(nolock) on J.Num_Proc_HBO =LBO.Num_Proc_LBO 
					where 
						substring(excprocesso,1,2) = @Modal and
						--year(convert(datetime,V.Dt_Criacao,103)) > @ActualYear and
						--year(convert(datetime,V.Dt_Criacao,103)) >= @ActualYear and
						(
							@Modal = 'IM' AND year(convert(datetime,V.Dt_Criacao,103)) > @ActualYear
							OR
							@Modal <> 'IM'
						)
						AND
						excreportmanager2 is null
						and
						(
							J.Num_Proc is null and isnull(LBO.Id_TP_Servico ,0) <> 1	
						)
					group by upper(excprocesso),V.Dt_Criacao 
					order by 2
					option(hash join)
			End
		End
GO
