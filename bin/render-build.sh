#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
bundle exec rails assets:precompile
bundle exec rails assets:clean

# Free プランには Pre-Deploy Command がないため、ビルド時に migrate する
bundle exec rails db:migrate

# 初回だけシード（デモ用ログインを入れる。2回目以降は既存データを上書きしない）
bundle exec rails runner 'load Rails.root.join("db/seeds.rb") if User.none?'
