module AdminController

using Genie, Genie.Renderer, Genie.Requests, Genie.Exceptions, Genie.Renderer.Html, Genie.Flash
using SearchLight, SearchLight.Relationships

using CRUDModels, CRUDOperations
using ViewHelper

using Contacts, Clients, Species, Tissuetypes
using Markers

export create, read, update, delete, list
export sidebar_links

import Base: parse
parse(T::Type{String}, str::String) = str
export parse


################################################################################
sidebar_links = [:client, :contact, :specie, :tissuetype]


################################################################################
################################################################################
function index()
    html(:admin, :index; context = @__MODULE__, sidebar_links = sidebar_links)
end

function create()
    model = get_model(payload(:model))
    field_types = model_field_types(model)
    attrs = Dict(field => parse(field_types[field], postpayload(field))
                 for field in intersect(keys(field_types), fieldnames(model)))
    object = model(; attrs...) |> save!
    flash("Object created successfully.")
    redirect(:admin_model_read, model = nameof(model), id = object.id)
end

function read()
    model = get_model(payload(:model); context = @__MODULE__)
    object = findone(model, id = payload(:id))
    if isnothing(object)
        flash("Object not found.")
        redirect(:admin_model_list, model = nameof(model))
    else
        html(:admin, :read; context = @__MODULE__, model = model, object = object, sidebar_links = sidebar_links)
    end
end

function update()
    #model = get_model(payload(:model))
    #object = findone(model, id = payload(:id))
    #if !isnothing(object)
    #    field_types = model_field_types(model)
    #    attrs = Dict(field => parse(field_types[field], postpayload(field))
    #                 for field in intersect(keys(field_types), fieldnames(model)))
    #    object = model_update(model, object; attrs)
    #    flash("Object updated successfully.")
    #else
    #    flash("Object not found.")
    #end
    redirect(:admin_model_read, model = model_symbol(model), id = object.id)
end

function delete()
    model = get_model(payload(:model))
    object = findone(model, id = payload(:id))
    if !isnothing(object)
        SearchLight.delete!(object)
        flash("Object deleted successfully.")
    else
        flash("Object not found.")
    end
    redirect(:admin_model_list, model = nameof(model))
end

function list()
    model = get_model(payload(:model); context = @__MODULE__)
    objects = all(model)
    html(:admin, :list; context = @__MODULE__, model = model, objects = objects, sidebar_links = sidebar_links)
end














end


